# PHP "*-fpm" Images

## The "*-fpm" Images

The FPM images extend the "*-base" image and have PHP-FPM installed.

This image exposes the port:
- 9000 for the FPM

## PHP "*-fpm-nginx" Images

The FPM-NGINX images extend the "\*-fpm" and "\*-base" images and also include
a full-featured LEMP Server: PHP + NGINX 1.12.x (without MySQL bundled).

This image exposes the ports:
- 80
- 443

The home directory is defined by the NGINX_ROOT environment variable. If not set, it defaults to `/var/www/html`.

To start, simply type:

```bash
docker run -v $PWD:/var/www/html -p 80:80 byjg/php:8.0-fpm-nginx
```

By default, NGINX serves all files in /var/www/html.

You can set your own NGINX configurations by attaching volumes to:
- /etc/nginx/nginx.conf
- /etc/nginx/http.d/   # Vhosts
- /etc/nginx/conf.d/   # Root level configuration


*Setting PHP Controller*

You can define a PHP Controller, which is a single PHP file that will process all requests. This is useful for
REST applications like Silex, Lumen, Symfony, etc.

```bash
docker run -e PHP_CONTROLLER="/index.php" byjg/php:8.0-fpm-nginx
```

*Setting SSL Certificate*

```bash
docker run -e NGINX_SSL_CERT=/opt/my.cert -e NGINX_SSL_CERT_KEY=/opt/my.key byjg/php:8.0-fpm-nginx
```

*Setting the NGINX Root*

You can set the NGINX Root directory by setting the environment variable `NGINX_ROOT`. This is useful when you want to
serve files from a different directory.

```bash
docker run -e NGINX_ROOT=/srv -v $PWD:/srv -p 80:80 byjg/php:8.0-fpm-nginx
```

*Setting the NGINX FastCGI*

You can set the NGINX FastCGI by setting the environment variable `PHP_FPM_SERVER`. This is useful when you want to
change the FPM port.

```bash
docker run -e PHP_FPM_SERVER=127.0.0.1:9000 byjg/php:8.0-fpm-nginx
```

## PHP "*-nginx" Images

The NGINX images have only the NGINX server installed and are configured to connect to a PHP-FPM server.

See the fpm-nginx image for more details.

## PHP "*-fpm-apache" Images

The FPM-APACHE images extend the "\*-fpm" and "\*-base" images and also include
a full-featured LAMP Server: PHP + APACHE 2.4.x (without MySQL bundled).

This image exposes the ports:
- 80
- 443

The home directory is in /srv.

To start, simply type:

```bash
docker run -v $PWD:/srv -p 80:80 byjg/php:8.0-fpm-apache
```

By default, Apache serves all files in /srv.

You can set your own APACHE configurations by attaching volumes to:
- /etc/apache2/httpd.conf
- /etc/apache2/conf.d/
