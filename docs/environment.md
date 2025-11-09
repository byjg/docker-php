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

#### `DISABLEMODULE_[name]`

Disable specific PHP modules at runtime. All modules are enabled by default.

```bash
docker run \
  -e DISABLEMODULE_DOM=true \
  -e DISABLEMODULE_XSL=true \
  byjg/php:8.3-cli
```

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
