---
sidebar_position: 7
---

# Dockerfile Example

You can extend the ByJG PHP images to create custom images for your application.

## Basic Dockerfile Example

### For CLI Applications

```dockerfile title="Dockerfile"
FROM byjg/php:8.3-cli

# Copy your application
COPY . /app
WORKDIR /app

# Install Composer dependencies
RUN composer install --no-dev --optimize-autoloader

# Run your application
CMD ["php", "app.php"]
```

### For Web Applications (Nginx)

```dockerfile title="Dockerfile"
FROM byjg/php:8.3-fpm-nginx

# Configure web server
ENV NGINX_ROOT=/var/www/html
ENV PHP_CONTROLLER=/index.php

# Copy application files
COPY . /var/www/html

# Install dependencies
RUN composer install --no-dev --optimize-autoloader

EXPOSE 80
```

### For Web Applications (Apache)

```dockerfile title="Dockerfile"
FROM byjg/php:8.3-fpm-apache

# Copy application files
COPY . /srv

# Install dependencies
RUN composer install --no-dev --optimize-autoloader

EXPOSE 80
```

## Advanced Configuration

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

# Disable unnecessary modules for better performance
# ENV DISABLEMODULE_bcmath=1
# ENV DISABLEMODULE_ctype=1
# ENV DISABLEMODULE_curl=1
# ENV DISABLEMODULE_dba=1
# ENV DISABLEMODULE_dom=1
# ENV DISABLEMODULE_fileinfo=1
# ENV DISABLEMODULE_ftp=1
# ENV DISABLEMODULE_gd=1
# ENV DISABLEMODULE_gettext=1
# ENV DISABLEMODULE_iconv=1
# ENV DISABLEMODULE_intl=1
# ENV DISABLEMODULE_mbstring=1
# ENV DISABLEMODULE_openssl=1
# ENV DISABLEMODULE_pcntl=1
# ENV DISABLEMODULE_pdo=1
# ENV DISABLEMODULE_posix=1
# ENV DISABLEMODULE_session=1
# ENV DISABLEMODULE_shmop=1
# ENV DISABLEMODULE_simplexml=1
# ENV DISABLEMODULE_soap=1
# ENV DISABLEMODULE_sockets=1
# ENV DISABLEMODULE_sqlite3=1
# ENV DISABLEMODULE_tokenizer=1
# ENV DISABLEMODULE_xml=1
# ENV DISABLEMODULE_xmlwriter=1
# ENV DISABLEMODULE_zip=1
# ENV DISABLEMODULE_exif=1
# ENV DISABLEMODULE_mysqlnd=1
# ENV DISABLEMODULE_pdo_dblib=1
# ENV DISABLEMODULE_pdo_pgsql=1
# ENV DISABLEMODULE_pdo_sqlite=1
# ENV DISABLEMODULE_phar=1
# ENV DISABLEMODULE_xmlreader=1
# ENV DISABLEMODULE_xsl=1
# ENV DISABLEMODULE_mysqli=1
# ENV DISABLEMODULE_pdo_mysql=1
# ENV DISABLEMODULE_igbinary=1
# ENV DISABLEMODULE_memcached=1
# ENV DISABLEMODULE_redis=1
# ENV DISABLEMODULE_msgpack=1
# ENV DISABLEMODULE_xdebug=1
# ENV DISABLEMODULE_yaml=1
# ENV DISABLEMODULE_mcrypt=1
# ENV DISABLEMODULE_mongodb=1

# Copy application
COPY . /app
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
COPY composer.json composer.lock ./
RUN composer install --no-dev --optimize-autoloader --no-scripts

COPY . .

# Production stage
FROM byjg/php:8.3-fpm-nginx

# Copy only production files
COPY --from=builder /app /var/www/html

# Configure for production
ENV PHP_CONTROLLER=/index.php
ENV NGINX_ROOT=/var/www/html/public

# Disable XDebug in production
ENV DISABLEMODULE_xdebug=1

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
