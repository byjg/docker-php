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
        self.local_base = False
        print("--------------------------------------------")
        print("PHP Version: " + php_version)
        print("Debug: " + ("true" if debug else "false"))
        print("--------------------------------------------")
        self._run_cli(["podman", "run", "--rm", "--events-backend=file", "--cgroup-manager=cgroupfs", "--privileged", "docker://multiarch/qemu-user-static", "--reset", "-p", "yes"])
        
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

    def _build(self, container, config, arch):
        config_template = "php-" + config + ".j2"
        image = "{image}-{arch}".format(
            image=self.imageName(config),
            arch=arch
        )
        self._run_cli(["buildah", "config", "--env", "DOCKER_IMAGE={image}".format(image=image), container])
        self._run_cli(["buildah", "config", "--env", "PHP_VERSION={major}.{minor}".format(major=self.content["version"]["major"], minor=self.content["version"]["minor"]), container])
        self._run_cli(["buildah", "config", "--env", "PHP_VARIANT=php{suffix}".format(suffix=self.content["version"]["suffix"]), container])
        if not self.debug:
            [self._run_cli(["buildah", "run", container, "/bin/sh", "-c", command]) for command in self.parse_config(config_template)]
        else:
            self._run_cli(["buildah", "run", container, "/bin/sh", "-c", " \\\n && ".join(self.parse_config(config_template))])
        self._run_cli(["buildah", "config", "--env", "BUILD_DATE={date}".format(date=self.build_date), container])
        self._run_cli(["buildah", "commit", "--iidfile", "/tmp/iid", container, "containers-storage:localhost/{image}".format(image=image)])
        with open('/tmp/iid', 'r') as f:
            iid = f.read()
        return iid

    def _from(self, image, arch):
        cmd = "buildah --arch {arch} from {image}".format(image=image, arch=arch)
        if self.debug:
            print("\n>>>> " + cmd)
        return subprocess.check_output(cmd, shell=True).decode("UTF-8").strip()

    def imageName(self, config):
        return "byjg/php:{major}.{minor}-{config}".format(
            major=self.content["version"]["major"],
            minor=self.content["version"]["minor"],
            config=config.replace("_", "-")
        )

    def source_repo(self, arch, php_source):
        return "{source_repo}byjg/php:{major}.{minor}-{php_source}{arch}".format(
            source_repo="containers-storage:localhost/" if self.local_base else "docker://",
            major=self.content["version"]["major"],
            minor=self.content["version"]["minor"],
            php_source=php_source,
            arch="-" + arch if self.local_base else "")

    def manifest_create(self, config):
        self._run_cli(["buildah", "manifest", "create", self.imageName(config)])

    def manifest_add(self, iid, config, arch):
        self._run_cli(["buildah", "manifest", "add", self.imageName(config), "--arch", arch]
                      + (["--variant", "v8"] if arch in ['arm64', 'aarch64'] else [])
                      + [iid])

    def manifest_push(self, config):
        if not self.push:
            return
        local_image = "containers-storage:localhost/" + self.imageName(config)
        image_month = "{image}-{year}.{month:02d}".format(image=self.imageName(config), year=date.today().year, month=date.today().month)
        self._run_cli(["buildah", "manifest", "push", "--all", "--format", "v2s2", local_image, "docker://" + self.imageName(config)])
        self._run_cli(["buildah", "manifest", "push", "--all", "--format", "v2s2", local_image, "docker://" + image_month])

    def build_base(self, arch):
        self._banner("base")
        base_image = self.content["image"][arch] if arch in self.content["image"] else self.content["image"]["default"]
        container = self._from("docker://" + base_image, arch)
        self._run_cli(["buildah", "config", "--entrypoint", '["/entrypoint.sh"]', container])
        self._run_cli(["buildah", "config", "--workingdir", "/srv", container])
        self._run_cli(["buildah", "copy", container, "assets/entrypoint.sh", "/"])
        self._run_cli(["buildah", "copy", container, "assets/script/install-sqlsvr.sh", "/install-sqlsvr.sh"])
        self.local_base = True
        return self._build(container, "base", arch)

    def build_cli(self, arch):
        self._banner("cli")
        container = self._from(self.source_repo(arch, "base"), arch)
        return self._build(container, "cli", arch)

    def build_fpm(self, arch):
        self._banner("fpm")
        container = self._from(self.source_repo(arch, "base"), arch)
        self._run_cli(["buildah", "config", "--cmd", 'php-fpm --nodaemonize', container])
        self._run_cli(["buildah", "copy", container, "assets/fpm/conf/www.conf", "/etc/php{major}{minor}/php-fpm.d/www.conf".format(major=self.content["version"]["major"], minor=self.content["version"]["minor"])])

        return self._build(container, "fpm", arch)

    def build_fpm_apache(self, arch):
        self._banner("fpm-apache")
        container = self._from(self.source_repo(arch, "fpm"), arch)
        self._run_cli(["buildah", "config", "--cmd", '/usr/bin/supervisord -n -c /etc/supervisord.conf', container])
        self._run_cli(["buildah", "copy", container, "assets/fpm-apache/conf/httpd.conf", "/etc/apache2/httpd.conf"])
        self._run_cli(["buildah", "copy", container, "assets/fpm-apache/conf/vhost.conf", "/etc/apache2/conf.d/"])
        self._run_cli(["buildah", "copy", container, "assets/fpm-apache/conf/supervisord.conf", "/etc/supervisord.conf"])
        self._run_cli(["buildah", "copy", container, "assets/script/exit-event-listener.py", "/exit-event-listener.py"])
        self._run_cli(["buildah", "copy", container, "assets/script/start-fpm.sh", "/start-fpm.sh"])
        return self._build(container, "fpm-apache", arch)

    def build_fpm_nginx(self, arch):
        self._banner("fpm-nginx")
        container = self._from(self.source_repo(arch, "fpm"), arch)
        self._run_cli(["buildah", "config", "--cmd", '/usr/bin/supervisord -n -c /etc/supervisord.conf', container])
        self._run_cli(["buildah", "copy", container, "assets/fpm-nginx/conf/nginx.conf", "/etc/nginx/nginx.conf"])
        self._run_cli(["buildah", "copy", container, "assets/fpm-nginx/conf/nginx.vh.default.conf", "/etc/nginx/http.d/default.conf"])
        self._run_cli(["buildah", "copy", container, "assets/fpm-nginx/conf/supervisord.conf", "/etc/supervisord.conf"])
        self._run_cli(["buildah", "copy", container, "assets/script/exit-event-listener.py", "/exit-event-listener.py"])
        self._run_cli(["buildah", "copy", container, "assets/script/start-fpm.sh", "/start-fpm.sh"])
        script = self.parse_config("php-fpm-nginx.j2", False)
        with open(".tmp.sh", "w") as file:
            file.write(script)
        self._run_cli(["buildah", "copy", container, ".tmp.sh", "/tmp/install_nginx.sh"])
        return self._build(container, "fpm-nginx", arch)

    def build_nginx(self, arch):
        self._banner("nginx")
        base_image = self.content["image"][arch] if arch in self.content["image"] else self.content["image"]["default"]
        container = self._from("docker://" + base_image, arch)
        self._run_cli(["buildah", "config", "--cmd", "nginx -g \"'daemon off;'\"", container])
        self._run_cli(["buildah", "config", "--entrypoint", '["/entrypoint.sh"]', container])
        self._run_cli(["buildah", "config", "--workingdir", "/srv", container])
        self._run_cli(["buildah", "copy", container, "assets/fpm-nginx/conf/nginx.conf", "/etc/nginx/nginx.conf"])
        self._run_cli(["buildah", "copy", container, "assets/fpm-nginx/conf/nginx.vh.default.conf", "/etc/nginx/http.d/default.conf"])
        self._run_cli(["buildah", "copy", container, "assets/entrypoint.sh", "/"])
        return self._build(container, "nginx", arch)
