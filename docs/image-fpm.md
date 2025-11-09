---
sidebar_position: 3
---

# PHP "*-fpm" Images

## The `*-fpm` Images

The FPM images extend the `*-base` image and include PHP-FPM (FastCGI Process Manager).

### Exposed Ports

| Port | Purpose |
|------|---------|
| 9000 | PHP-FPM |

### Usage

```bash
docker run -d -p 9000:9000 byjg/php:8.3-fpm
```

:::note
The `*-fpm` images require an external web server (like Nginx or Apache) to proxy requests to PHP-FPM. For all-in-one solutions, use `*-fpm-nginx` or `*-fpm-apache` variants.
:::

## The `*-fpm-nginx` Images

The FPM-NGINX images provide a complete LEMP stack (Linux + Nginx + MySQL + PHP) without MySQL bundled.

### Exposed Ports

| Port | Purpose |
|------|---------|
| 80   | HTTP    |
| 443  | HTTPS   |

### Quick Start

```bash
docker run -d \
  -v $PWD:/var/www/html \
  -p 80:80 \
  byjg/php:8.3-fpm-nginx
```

By default, Nginx serves all files from `/var/www/html` (configurable via `NGINX_ROOT`).

### Configuration

You can customize Nginx by mounting configuration files:

| Path                    | Purpose                          |
|------------------------|----------------------------------|
| `/etc/nginx/nginx.conf` | Main Nginx configuration        |
| `/etc/nginx/http.d/`    | Virtual host configurations     |
| `/etc/nginx/conf.d/`    | Root-level Nginx configurations |

```bash
docker run -d \
  -v $PWD/nginx.conf:/etc/nginx/nginx.conf \
  -v $PWD:/var/www/html \
  -p 80:80 \
  byjg/php:8.3-fpm-nginx
```


### Common Configuration Scenarios

#### Single Entry Point (PHP Controller)

For frameworks like Symfony, Laravel, or Slim:

```bash
docker run -d \
  -e PHP_CONTROLLER="/index.php" \
  -v $PWD:/var/www/html \
  -p 80:80 \
  byjg/php:8.3-fpm-nginx
```

:::tip
This routes all requests through a single PHP file, which is the standard pattern for most modern PHP frameworks.
:::

#### Custom Document Root

```bash
docker run -d \
  -e NGINX_ROOT=/srv/public \
  -v $PWD:/srv \
  -p 80:80 \
  byjg/php:8.3-fpm-nginx
```

#### HTTPS/SSL Configuration

```bash
docker run -d \
  -e NGINX_SSL_CERT=/opt/my.cert \
  -e NGINX_SSL_CERT_KEY=/opt/my.key \
  -v /path/to/certs:/opt \
  -p 443:443 \
  byjg/php:8.3-fpm-nginx
```

#### Custom PHP-FPM Server

```bash
docker run -d \
  -e PHP_FPM_SERVER=127.0.0.1:9000 \
  -p 80:80 \
  byjg/php:8.3-fpm-nginx
```

## The `*-nginx` Images

Standalone Nginx images configured to connect to an external PHP-FPM server.

:::info
See the `*-fpm-nginx` section above for configuration details. These images work the same way but require you to provide your own PHP-FPM server.
:::

## The `*-fpm-apache` Images

The FPM-APACHE images provide a complete LAMP stack (Linux + Apache + MySQL + PHP) without MySQL bundled.

### Exposed Ports

| Port | Purpose |
|------|---------|
| 80   | HTTP    |
| 443  | HTTPS   |

### Quick Start

```bash
docker run -d \
  -v $PWD:/srv \
  -p 80:80 \
  byjg/php:8.3-fpm-apache
```

By default, Apache serves all files from `/srv`.

### Configuration

You can customize Apache by mounting configuration files:

| Path                       | Purpose                          |
|---------------------------|----------------------------------|
| `/etc/apache2/httpd.conf` | Main Apache configuration        |
| `/etc/apache2/conf.d/`    | Additional Apache configurations |

```bash
docker run -d \
  -v $PWD/httpd.conf:/etc/apache2/httpd.conf \
  -v $PWD:/srv \
  -p 80:80 \
  byjg/php:8.3-fpm-apache
```
