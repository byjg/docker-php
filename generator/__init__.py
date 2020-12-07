import os, sys
import yaml
import subprocess
from jinja2 import Environment, FileSystemLoader


class Generator:
    def __init__(self, php_version, debug):
        content = "{dir}/config/php-{version}.yml".format(dir=os.getcwd(), version=php_version)

        if not os.path.exists(content):
            print('PHP Version {version} does not exists'.format(version=php_version))
            sys.exit(1)

        self.php_version = php_version
        self.debug = debug
        self.content = yaml.load(stream=open(content), Loader=yaml.SafeLoader)
        print("PHP Version: " + php_version)
        print("Debug: " + ("true" if debug else "false"))
        print("--------------------------------------------")

    def parse_config(self, template, prepared=True):
        file_loader = FileSystemLoader('templates')
        env = Environment(loader=file_loader)
        template = env.get_template(template)
        output = template.render(self.content)

        if prepared:
            return map(lambda x: "echo == COMMAND: {x} \\\n && {y}".format(y=x, x=x.replace("|", "...").replace(">", "...").replace("<", "...").replace(";", "...")), filter(lambda x: not x.startswith('#') and x != "", output.split("\n")))

        return output

    def _banner(self, config):
        print("")
        print("")
        print("===================================================================")
        print("Building PHP {major}.{minor}-{config}".format(major=self.content["version"]["major"], minor=self.content["version"]["minor"], config=config))
        print("===================================================================")
        print("")

    def _build(self, container, config):
        config_template = "php-" + config + ".j2"
        image = "byjg/php:{major}.{minor}-{config}".format(major=self.content["version"]["major"], minor=self.content["version"]["minor"], config=config)
        subprocess.run(["buildah", "config", "--env", "DOCKER_IMAGE={image}".format(image=image), container], check=True)
        if self.debug:
            [subprocess.run(["buildah", "run", container, "/bin/sh", "-c", command], check=True) for command in self.parse_config(config_template)]
        else:
            subprocess.run(["buildah", "run", container, "/bin/sh", "-c", " \\\n && ".join(self.parse_config(config_template))], check=True)
        subprocess.run(["buildah", "commit", container, "localhost/{image}".format(image=image)])
        subprocess.run(["buildah", "tag", "localhost/byjg/php:{image}".format(image=image), "docker.io/byjg/php:{image}".format(image=image)])
        subprocess.run(["buildah", "push", "docker.io/byjg/php:{image}".format(image=image)])

    def build_base(self):
        self._banner("base")
        container = subprocess.check_output("buildah from {image}".format(image=self.content["image"]), shell=True).decode("UTF-8").strip()
        subprocess.run(["buildah", "config", "--entrypoint", '["/entrypoint.sh"]', container], check=True)
        subprocess.run(["buildah", "config", "--workingdir", "/srv/web", container], check=True)
        subprocess.run(["buildah", "copy", container, "assets/entrypoint.sh", "/"], check=True)
        self._build(container, "base")

    def build_cli(self):
        self._banner("cli")
        container = subprocess.check_output("buildah from localhost/byjg/php:{major}.{minor}-base".format(major=self.content["version"]["major"], minor=self.content["version"]["minor"]), shell=True).decode("UTF-8").strip()
        self._build(container, "cli")

    def build_fpm(self):
        self._banner("fpm")
        container = subprocess.check_output("buildah from localhost/byjg/php:{major}.{minor}-base".format(major=self.content["version"]["major"], minor=self.content["version"]["minor"]), shell=True).decode("UTF-8").strip()
        subprocess.run(["buildah", "config", "--cmd", 'php-fpm --nodaemonize', container], check=True)
        subprocess.run(["buildah", "copy", container, "assets/fpm-nginx/conf/php-fpm.conf", "/etc/php{major}/php-fpm.conf".format(major=self.content["version"]["major"])], check=True)
        self._build(container, "fpm")

    def build_fpm_apache(self):
        self._banner("fpm-apache")
        container = subprocess.check_output("buildah from localhost/byjg/php:{major}.{minor}-fpm".format(major=self.content["version"]["major"], minor=self.content["version"]["minor"]), shell=True).decode("UTF-8").strip()
        subprocess.run(["buildah", "config", "--cmd", '/usr/bin/supervisord -n -c /etc/supervisord.conf', container], check=True)
        subprocess.run(["buildah", "copy", container, "assets/fpm-apache/conf/httpd.conf", "/etc/apache2/httpd.conf"], check=True)
        subprocess.run(["buildah", "copy", container, "assets/fpm-apache/conf/vhost.conf", "/etc/apache2/conf.d/"], check=True)
        subprocess.run(["buildah", "copy", container, "assets/fpm-apache/conf/supervisord.conf", "/etc/supervisord.conf"], check=True)
        subprocess.run(["buildah", "copy", container, "assets/script/exit-event-listener.py", "/exit-event-listener.py"], check=True)
        subprocess.run(["buildah", "copy", container, "assets/script/start-fpm.sh", "/start-fpm.sh"], check=True)
        self._build(container, "fpm-apache")

    def build_fpm_nginx(self):
        self._banner("fpm-nginx")
        container = subprocess.check_output("buildah from localhost/byjg/php:{major}.{minor}-fpm".format(major=self.content["version"]["major"], minor=self.content["version"]["minor"]), shell=True).decode("UTF-8").strip()
        subprocess.run(["buildah", "config", "--cmd", '/usr/bin/supervisord -n -c /etc/supervisord.conf', container], check=True)
        subprocess.run(["buildah", "copy", container, "assets/fpm-nginx/conf/nginx.conf", "/etc/nginx/nginx.conf"], check=True)
        subprocess.run(["buildah", "copy", container, "assets/fpm-nginx/conf/nginx.vh.default.conf", "/etc/nginx/conf.d/default.conf"], check=True)
        subprocess.run(["buildah", "copy", container, "assets/fpm-nginx/conf/supervisord.conf", "/etc/supervisord.conf"], check=True)
        subprocess.run(["buildah", "copy", container, "assets/script/exit-event-listener.py", "/exit-event-listener.py"], check=True)
        subprocess.run(["buildah", "copy", container, "assets/script/start-fpm.sh", "/start-fpm.sh"], check=True)
        script = self.parse_config("php-fpm-nginx-build.j2", False)
        with open(".tmp.sh", "w") as file:
            file.write(script)
        subprocess.run(["buildah", "copy", container, ".tmp.sh", "/tmp/install_nginx.sh"], check=True)
        self._build(container, "fpm-nginx")
