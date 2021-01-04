import os, sys
import yaml
import subprocess
from jinja2 import Environment, FileSystemLoader
from datetime import datetime, date

class Generator:
    def __init__(self, php_version, debug, push):
        content = "{dir}/config/php-{version}.yml".format(dir=os.getcwd(), version=php_version)

        if not os.path.exists(content):
            print('PHP Version {version} does not exists'.format(version=php_version))
            sys.exit(1)

        self.php_version = php_version
        self.debug = debug
        self.push = push
        self.build_date = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        self.content = yaml.load(stream=open(content), Loader=yaml.SafeLoader)
        print("--------------------------------------------")
        print("PHP Version: " + php_version)
        print("Debug: " + ("true" if debug else "false"))
        print("--------------------------------------------")
        
    def _run_cli(self, cmds):
        if self.debug:
            print("\n>>>> " + " ".join(cmds))
        subprocess.run(cmds, check=True)

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
        imageMonth = "{image}-{year}.{month:02d}".format(image=image, year=date.today().year, month=date.today().month)
        self._run_cli(["buildah", "config", "--env", "DOCKER_IMAGE={image}".format(image=image), container])
        self._run_cli(["buildah", "config", "--env", "PHP_VERSION={major}.{minor}".format(major=self.content["version"]["major"], minor=self.content["version"]["minor"]), container])
        self._run_cli(["buildah", "config", "--env", "PHP_VARIANT=php{major}".format(major=self.content["version"]["major"]), container])
        if not self.debug:
            [self._run_cli(["buildah", "run", container, "/bin/sh", "-c", command]) for command in self.parse_config(config_template)]
        else:
            self._run_cli(["buildah", "run", container, "/bin/sh", "-c", " \\\n && ".join(self.parse_config(config_template))])
        self._run_cli(["buildah", "config", "--env", "BUILD_DATE={date}".format(date=self.build_date), container])
        self._run_cli(["buildah", "commit", container, "localhost/{image}".format(image=image)])
        self._run_cli(["buildah", "tag", "localhost/{image}".format(image=image), "docker.io/{image}".format(image=image)])
        self._run_cli(["buildah", "tag", "localhost/{image}".format(image=image), "docker.io/{image}".format(image=imageMonth)])
        if self.push:
            self._run_cli(["buildah", "push", "docker.io/{image}".format(image=image)])
            self._run_cli(["buildah", "push", "docker.io/{image}".format(image=imageMonth)])

    def build_base(self):
        self._banner("base")
        container = subprocess.check_output("buildah from {image}".format(image=self.content["image"]), shell=True).decode("UTF-8").strip()
        self._run_cli(["buildah", "config", "--entrypoint", '["/entrypoint.sh"]', container])
        self._run_cli(["buildah", "config", "--workingdir", "/srv/web", container])
        self._run_cli(["buildah", "copy", container, "assets/entrypoint.sh", "/"])
        self._build(container, "base")

    def build_cli(self):
        self._banner("cli")
        container = subprocess.check_output("buildah from localhost/byjg/php:{major}.{minor}-base".format(major=self.content["version"]["major"], minor=self.content["version"]["minor"]), shell=True).decode("UTF-8").strip()
        self._build(container, "cli")

    def build_fpm(self):
        self._banner("fpm")
        container = subprocess.check_output("buildah from localhost/byjg/php:{major}.{minor}-base".format(major=self.content["version"]["major"], minor=self.content["version"]["minor"]), shell=True).decode("UTF-8").strip()
        self._run_cli(["buildah", "config", "--cmd", 'php-fpm --nodaemonize', container])
        self._build(container, "fpm")

    def build_fpm_apache(self):
        self._banner("fpm-apache")
        container = subprocess.check_output("buildah from localhost/byjg/php:{major}.{minor}-fpm".format(major=self.content["version"]["major"], minor=self.content["version"]["minor"]), shell=True).decode("UTF-8").strip()
        self._run_cli(["buildah", "config", "--cmd", '/usr/bin/supervisord -n -c /etc/supervisord.conf', container])
        self._run_cli(["buildah", "copy", container, "assets/fpm-apache/conf/httpd.conf", "/etc/apache2/httpd.conf"])
        self._run_cli(["buildah", "copy", container, "assets/fpm-apache/conf/vhost.conf", "/etc/apache2/conf.d/"])
        self._run_cli(["buildah", "copy", container, "assets/fpm-apache/conf/supervisord.conf", "/etc/supervisord.conf"])
        self._run_cli(["buildah", "copy", container, "assets/script/exit-event-listener.py", "/exit-event-listener.py"])
        self._run_cli(["buildah", "copy", container, "assets/script/start-fpm.sh", "/start-fpm.sh"])
        self._build(container, "fpm-apache")

    def build_fpm_nginx(self):
        self._banner("fpm-nginx")
        container = subprocess.check_output("buildah from localhost/byjg/php:{major}.{minor}-fpm".format(major=self.content["version"]["major"], minor=self.content["version"]["minor"]), shell=True).decode("UTF-8").strip()
        self._run_cli(["buildah", "config", "--cmd", '/usr/bin/supervisord -n -c /etc/supervisord.conf', container])
        self._run_cli(["buildah", "copy", container, "assets/fpm-nginx/conf/nginx.conf", "/etc/nginx/nginx.conf"])
        self._run_cli(["buildah", "copy", container, "assets/fpm-nginx/conf/nginx.vh.default.conf", "/etc/nginx/conf.d/default.conf"])
        self._run_cli(["buildah", "copy", container, "assets/fpm-nginx/conf/supervisord.conf", "/etc/supervisord.conf"])
        self._run_cli(["buildah", "copy", container, "assets/script/exit-event-listener.py", "/exit-event-listener.py"])
        self._run_cli(["buildah", "copy", container, "assets/script/start-fpm.sh", "/start-fpm.sh"])
        script = self.parse_config("php-fpm-nginx-build.j2", False)
        with open(".tmp.sh", "w") as file:
            file.write(script)
        self._run_cli(["buildah", "copy", container, ".tmp.sh", "/tmp/install_nginx.sh"])
        self._build(container, "fpm-nginx")
