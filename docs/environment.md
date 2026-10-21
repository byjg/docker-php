---
sidebar_position: 4
---

# Environment Variables

You can configure the `byjg/php` images using environment variables without modifying configuration files. All environment variables are accessible by your running PHP instance.

## Configuration Variables

### Web Server Configuration

#### `PHP_CONTROLLER`

Enable single-file controller pattern (for `fpm-nginx` and `fpm-apache` images). All requests will be routed to the specified PHP file.

**Default:** Not set

```bash
docker run -e PHP_CONTROLLER=/app.php byjg/php:8.3-fpm-nginx
```

:::note Use Case
This is useful for frameworks like Symfony, Laravel, or Slim that use a single entry point.
:::

#### `NGINX_ROOT`

Set the web server document root.

**Default:** `/var/www/html`

```bash
docker run -e NGINX_ROOT=/srv/public byjg/php:8.3-fpm-nginx
```

#### `PHP_FPM_SERVER`

Configure the FastCGI server address for PHP-FPM.

**Default:** `127.0.0.1:9000`

```bash
docker run -e PHP_FPM_SERVER=127.0.0.1:9000 byjg/php:8.3-fpm-nginx
```

### SSL/TLS Configuration

#### `NGINX_SSL_CERT` and `NGINX_SSL_CERT_KEY`

Enable HTTPS by providing paths to SSL certificate and key files.

**Default:** Not set (HTTP only)

```bash
docker run \
  -v /etc/ssl:/etc/ssl \
  -e NGINX_SSL_CERT=/etc/ssl/my.cert \
  -e NGINX_SSL_CERT_KEY=/etc/ssl/my.key \
  byjg/php:8.3-fpm-nginx
```

### PHP Module Management

#### `PHP_DISABLE_MODULES`

Disable PHP modules when the container starts. A comma or space separated list of module names.
All modules are enabled by default. The modules that require a disabled one are disabled too:
`dom` also disables `xmlreader` and `xsl`.

```bash
docker run \
  -e PHP_DISABLE_MODULES="dom,xsl" \
  byjg/php:8.3-cli
```

#### `PHP_ENABLED_MODULES`

Disable every module except these, when the container starts. A comma or space separated list of
module names. The modules they require are kept too: `pdo_mysql` also keeps `pdo`, `mysqlnd` and
`openssl`.

```bash
docker run \
  -e PHP_ENABLED_MODULES="pdo_mysql,mbstring" \
  byjg/php:8.3-cli
```

For both variables, if a module is not found, or PHP does not start cleanly afterwards, the
container stops with an error instead of running with the wrong modules. A module already disabled,
e.g. after `docker restart`, is not an error. `VERBOSE=true` also shows each module disabled.

When both are set, `PHP_ENABLED_MODULES` is applied first and `PHP_DISABLE_MODULES` after it, so
`PHP_ENABLED_MODULES="pdo_mysql,xdebug"` with `PHP_DISABLE_MODULES="xdebug"` keeps only `pdo_mysql`
and what it requires.

To see the modules that can be disabled in an image, run
`docker run --rm byjg/php:8.5-cli php-disable-module --list`. To disable modules once, when
building your own image, use the `php-disable-module` helper instead (see
[Disabling modules](dockerfile.md#disabling-modules)).

:::warning Deprecated
`DISABLEMODULE_<name>=true` still works, but it is deprecated and will be removed in a future
release. Use `PHP_DISABLE_MODULES` instead.
:::

:::tip
Disabling unused modules can slightly improve performance and reduce memory footprint.
:::

### PHP-FPM Configuration

#### `PHP_FPM_IGNORE_ENV`

Prevent PHP-FPM from inheriting system environment variables.

**Default:** Not set (environment variables are passed to PHP)

```bash
docker run -e PHP_FPM_IGNORE_ENV=true byjg/php:8.3-fpm
```

### Debugging

#### `VERBOSE`

Enable verbose logging for troubleshooting startup and configuration.

**Default:** Not set

```bash
docker run -e VERBOSE=true byjg/php:8.3-cli
```

## Read-Only Environment Variables

These variables are set automatically by the image and provide information about the running container:

| Variable        | Description                                   | Example  |
|-----------------|-----------------------------------------------|----------|
| `DOCKER_IMAGE`  | The name of the image that is running        | `byjg/php:8.3-cli` |
| `PHP_VERSION`   | The PHP version that is running              | `8.3`    |
| `PHP_VARIANT`   | The PHP major version that is running        | `8`      |
| `BUILD_DATE`    | The date when the image was built            | `2024-10-15` |

:::info
These variables are automatically available in your PHP code via `getenv()` or `$_ENV`.
:::
