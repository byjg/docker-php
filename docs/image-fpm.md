# # PHP "*-fpm" Images

## The "*-fpm" Images

The FPM images extends the "*-base" Image and have installed the modules PHP-FPM.

This image exposes the port:
- 9000 for the FPM

## PHP "*-fpm-nginx" Images

The FPM-NGINX images extends "\*-fpm" and "\*-base" images and have also
a full featured LEMP Server: PHP + NGINX 1.12.x (without mysql bundled).

This image exposes the ports:
- 80
- 443

The home directory is defined by the NGINX_ROOT environment variable. If not set defaults to  `/var/www/html`.

Basically to start type:

```bash
docker run -v $PWD:/var/www/html -p 80:80 byjg/php:7.2-fpm-nginx
```

By default the nginx serves all files in /var/www/html.

You can set your own FPM configurations by attaching a volume to:
- /etc/nginx/nginx.conf
- /etc/nginx/conf.d/default.conf


*Setting PHP Controller*

You can define a PHP Controller which is a single PHP file that will process all request. This could be useful for
REST Applications like Silex, Lumen, Symfony, etc.

```bash
docker run -e PHP_CONTROLLER="/index.php" byjg/php:7.2-fpm-nginx
```

*Setting SSL Certificate*


```bash
docker run -e NGINX_SSL_CERT=/opt/my.cert NGINX_SSL_CERT_KEY=/opt/my.key byjg/php:7.2-fpm-nginx
```

## PHP "*-fpm-apache" Images

The FPM-APACHE images extends "\*-fpm" and "\*-base" images and have also
a full featured LAMP Server: PHP + APACHE 2.4.x (without mysql bundled).

This image exposes the ports:
- 80
- 443

The home directory is in /srv/web.

Basically to start type:

```bash
docker run -v $PWD:/srv/web -p 80:80 byjg/php:7.2-fpm-apache
```

By default the nginx serves all files in /srv/web.

You can set your own APACHE configurations by attaching a volume to:
- /etc/apache2/httpd.conf
- /etc/apache2/conf.d/
