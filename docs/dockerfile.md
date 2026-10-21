---
sidebar_position: 7
---

# Dockerfile Example

You can extend the ByJG PHP images to create custom images for your application.

## Basic Dockerfile Example

### For CLI Applications

```dockerfile title="Dockerfile"
FROM byjg/php:8.3-cli

# Copy your application with proper ownership
COPY --chown=app:app . /app
WORKDIR /app

# Install Composer dependencies
RUN composer install --no-dev --optimize-autoloader

# Run your application
CMD ["php", "app.php"]
```

:::tip Non-Root User
The image runs as the `app` user by default. Use `--chown=app:app` when copying files to ensure proper permissions.
:::

### For Web Applications (Nginx)

```dockerfile title="Dockerfile"
FROM byjg/php:8.3-fpm-nginx

# Configure web server
ENV NGINX_ROOT=/var/www/html
ENV PHP_CONTROLLER=/index.php

# Copy application files with proper ownership
COPY --chown=app:app . /var/www/html

# Install dependencies
RUN composer install --no-dev --optimize-autoloader

EXPOSE 80
```

### For Web Applications (Apache)

```dockerfile title="Dockerfile"
FROM byjg/php:8.3-fpm-apache

# Copy application files with proper ownership
COPY --chown=app:app . /srv

# Install dependencies
RUN composer install --no-dev --optimize-autoloader

EXPOSE 80
```

## Advanced Configuration

### Installing Additional Packages

When you need to install system packages, temporarily switch to root user:

```dockerfile title="Dockerfile"
FROM byjg/php:8.3-cli

# Switch to root to install packages
USER root
RUN apk add --no-cache php83-pecl-imagick

# Switch back to app user
USER app

# Copy application with proper ownership
COPY --chown=app:app . /app
WORKDIR /app

RUN composer install --no-dev --optimize-autoloader
```

:::warning
Always switch back to the `app` user after installing packages. Running your application as root negates security benefits.
:::

### Installing a PHP Extension with PIE

If the extension has no Alpine package (`apk search phpXY-pecl-<name>`), install it with
[PIE](https://github.com/php/pie), the PHP Foundation's replacement for PECL. The PHP 8.3+ images ship
`pie` and the `pie-install` helper; `pie-install` adds the compiler and the `phpXY-dev` package,
runs `pie install`, enables the extension and removes the build tools again, so they do not stay
in your image. It must run as `root`:

```dockerfile title="Dockerfile"
FROM byjg/php:8.5-cli

USER root
RUN pie-install apcu/apcu
USER app
```

Options (before the package name):

| Option                       | Description                                                          |
|------------------------------|----------------------------------------------------------------------|
| `--build-deps "<apk pkgs>"`  | Extra packages needed only to compile the extension (removed after)  |
| `--deps "<apk pkgs>"`        | Packages the extension needs at runtime (kept in the image)          |

Anything after the package name is passed to `pie install` (e.g. `--skip-enable-extension` or
configure options). The package accepts a version constraint, e.g. `xdebug/xdebug:^3.4`.

```dockerfile title="Dockerfile"
FROM byjg/php:8.5-cli

USER root
RUN pie-install --build-deps "imagemagick-dev" --deps "imagemagick" imagick/imagick
USER app
```

PIE enables the extension by writing `/etc/phpXY/conf.d/<priority>-<extension>.ini`; it can be
disabled like any other module (see [Disabling modules](#disabling-modules)). Find the PIE
package name of an extension on [Packagist](https://packagist.org/extensions).

:::note
PIE downloads the extension source from GitHub. When building many images from the same IP
(e.g. in CI) you may hit the GitHub API rate limit; set `GITHUB_TOKEN` in the build environment
to avoid it.
:::

#### Imagick on PHP 8.6

The PHP 8.6 images already contain a compiled `imagick.so`, but it is not enabled and the
ImageMagick runtime is not installed. There is nothing to compile; install the runtime and
enable the extension:

```dockerfile title="Dockerfile"
FROM byjg/php:8.6-cli

USER root
RUN apk add --no-cache imagemagick && \
    echo "extension=imagick.so" > /etc/php86/conf.d/imagick.ini
USER app
```

### Disabling modules

`php-disable-module` removes the ini file of one or more modules, so they are disabled in your image:

```dockerfile title="Dockerfile"
FROM byjg/php:8.5-cli

RUN php-disable-module xdebug soap ftp
```

It finds the module by the extension line of its ini file, whatever the file name: `70_yaml.ini`
(apk) or `80-yaml.ini` (PIE). It exits with an error if a module is not found, so a typo fails the
build; a module already disabled (e.g. by the base image) is not an error.

The modules that require a disabled one are disabled too, since they can no longer load:
`php-disable-module pdo` also disables `pdo_mysql`, `pdo_pgsql`, `pdo_sqlite` and `pdo_dblib`, and
prints each one with the module it requires. Afterwards it starts PHP once and fails if a module
does not load.

To keep only some modules and disable all the others, use `--all-except`:

```dockerfile title="Dockerfile"
FROM byjg/php:8.5-cli

RUN php-disable-module --all-except pdo_mysql mbstring
```

The modules they require are kept too (here `pdo`, `mysqlnd` and `openssl`), from what PHP
declares and from the Alpine package dependencies. Afterwards it starts PHP once and fails if a
module does not load, so a missing dependency fails the build instead of the container.

The modules that can be disabled vary a little by PHP version. List them with:

```bash
docker run --rm byjg/php:8.5-cli php-disable-module --list
```

To disable modules when the container starts instead, set
[`PHP_DISABLE_MODULES`](environment.md#php_disable_modules) or
[`PHP_ENABLED_MODULES`](environment.md#php_enabled_modules).

### Full Configuration Example

```dockerfile title="Dockerfile"
FROM byjg/php:8.3-cli

# Enable verbose mode for debugging
# ENV VERBOSE="true"

# Web server configuration (for fpm-nginx/fpm-apache)
ENV NGINX_ROOT=/var/www/html
ENV PHP_CONTROLLER=/index.php

# SSL/TLS configuration
# ENV NGINX_SSL_CERT=/path/to/ssl.crt
# ENV NGINX_SSL_CERT_KEY=/path/to/ssl.key

# Disable unnecessary modules for better performance. Every module that can be disabled in 8.5;
# the list varies a little by version: run "php-disable-module --list" in the image to see it.
# ENV PHP_DISABLE_MODULES="bcmath,ctype,curl,dba,dom,exif,fileinfo,ftp,gd,gettext,iconv,igbinary,intl,mbstring,memcached,mongodb,msgpack,mysqli,mysqlnd,openssl,pcntl,pdo,pdo_dblib,pdo_mysql,pdo_pgsql,pdo_sqlite,phar,posix,redis,session,shmop,simplexml,soap,sockets,sqlite3,tokenizer,xdebug,xml,xmlreader,xmlwriter,xsl,yaml,zip"

# Copy application with proper ownership
COPY --chown=app:app . /app
WORKDIR /app

# Install dependencies
RUN composer install --no-dev --optimize-autoloader
```

:::tip
See the [Environment Variables](environment.md) documentation for a complete list of available configuration options.
:::

## Multi-stage Builds

For production images, use multi-stage builds to keep image sizes small:

```dockerfile title="Dockerfile"
# Build stage
FROM byjg/php:8.3-cli AS builder

WORKDIR /app
COPY --chown=app:app composer.json composer.lock ./
RUN composer install --no-dev --optimize-autoloader --no-scripts

COPY --chown=app:app . .

# Production stage
FROM byjg/php:8.3-fpm-nginx

# Copy only production files with proper ownership
COPY --from=builder --chown=app:app /app /var/www/html

# Configure for production
ENV PHP_CONTROLLER=/index.php
ENV NGINX_ROOT=/var/www/html/public

# Disable XDebug in production
RUN php-disable-module xdebug

EXPOSE 80
```

## Docker Compose Example

```yaml title="docker-compose.yml"
version: '3.8'

services:
  app:
    image: byjg/php:8.3-fpm-nginx
    ports:
      - "80:80"
    volumes:
      - ./:/var/www/html
    environment:
      - PHP_CONTROLLER=/index.php
      - NGINX_ROOT=/var/www/html/public

  db:
    image: mysql:8.0
    environment:
      - MYSQL_ROOT_PASSWORD=secret
      - MYSQL_DATABASE=myapp
```
