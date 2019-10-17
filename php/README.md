# PHP Docker Images ByJG

A complete and small PHP Docker image based on Alpine Linux.

The Docker ByJG PHP Images has several bundled images based on PHP in different versions.

The PHP images are ready to use in:
 - Development Environment
 - Production Environment
 - CI/CD environments (like Travis-CI, Circle-CI, Jenkis, Bitbucket Pipelines, and others)

# Supported Tags

- 7.3-base
- 7.3-cli
- 7.3-fpm
- 7.3-fpm-apache
- 7.3-fpm-nginx
- 7.2-base
- 7.2-cli
- 7.2-fpm
- 7.2-fpm-apache
- 7.2-fpm-nginx
- 7.1-base
- 7.1-cli
- 7.1-fpm
- 7.1-fpm-apache
- 7.1-fpm-nginx
- 7.0-base
- 7.0-cli
- 7.0-fpm
- 7.0-fpm-apache
- 7.0-fpm-nginx
- 5.6-base
- 5.6-cli
- 5.6-fpm
- 5.6-fpm-apache
- 5.6-fpm-nginx

# The "*-base" Image 

All "*-base" images are based on Alpine Linux and only the necessary layers. Because of that the images 
are tiny and very optimized.

You can found more than 45 extensions pre-installed in all images:

```text
bcmath, ctype, curl, date, dba, dom, exif, fileinfo, filter, ftp, gd, gettext, hash, iconv, intl, 
json, libxml, mbstring, mcrypt, memcached, mongodb, mysqli, mysqlnd, openssl,pcntl, 
pcre, PDO, pdo_dblib, pdo_mysql, pdo_pgsql, pdo_sqlite, Phar, posix, readline, redis,
Reflection, session, SimpleXML, soap, sockets, SPL, sqlite3, standard, tokenizer, xdebug, xml, 
xmlreader, xmlwriter, xsl, zip, zlib, Xdebug
```

**plus** [Composer](https://getcomposer.org/) in the most recent version

Example:

```bash
docker run -it --rm byjg/php:7.1-base php --version
```

This image expose the port:
 - 9001 for the XDebug

## Adding Custom Config

You can create a volume or copy all *.ini files to `/etc/php/conf.d`

# PHP "*-cli" Images

The CLI images extends from "*-base" Image and have also:

- PHPUnit
- PHP Code Sniffer
- PHP Mess Detector
- PHP Code Beautifier and Fixer

You can create an alias to use easily the commands: 

```bash
alias php='docker run -it --rm -v "$PWD":/workdir -w /workdir -u $UID:${GROUPS[0]} byjg/php:7.2-cli php "$@"'
alias phpunit='docker run -it --rm -v "$PWD":/workdir -w /workdir -u $UID:${GROUPS[0]} byjg/php:7.2-cli phpunit "$@"'
alias phpcs='docker run -it --rm -v "$PWD":/workdir -w /workdir -u $UID:${GROUPS[0]} byjg/php:7.2-cli phpcs "$@"'
alias phpmd='docker run -it --rm -v "$PWD":/workdir -w /workdir -u $UID:${GROUPS[0]} byjg/php:7.2-cli phpmd "$@"'
```


# The "*-fpm" Images

The FPM images extends the "*-base" Image and have installed the modules PHP-FPM.

This image exposes the port:
- 9000 for the FPM

# PHP "*-fpm-nginx" Images

The FPM-NGINX images extends "\*-fpm" and "\*-base" images and have also 
a full featured LEMP Server: PHP + NGINX 1.12.x (without mysql bundled).

This image exposes the ports:
 - 80
 - 443

The home directory is in /var/www/html.

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

# PHP "*-fpm-apache" Images

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

# Image Sizes

Below a table with images uncompressed

| PHP Version   | base   | cli   | fpm    | fpm-nginx | fpm-apache |
|:-------------:|:------:|:-----:|:------:|:---------:|:----------:|
| 5.6           |   94MB | 131MB | 109MB  | 156MB     | 155MB      |
| 7.0           | 92.6MB | 136MB | 101MB  | 147MB     | 146MB      |
| 7.1           | 82.4MB | 126MB | 87MB   | 134MB     | 133MB      |
| 7.2           |   94MB | 140MB | 104MB  | 151MB     | 150MB      |
| 7.3           |   99MB | 151MB | 104MB  | 152MB     | 152MB      |

# Environment Variables

When you start the byjg/php image, you can adjust the configuration 
of the PHP instance by passing one or more environment variables on 
the docker run command line. 

Any ENVIRONMENT variable can be accessible by your running PHP Instance. 
 

## DISABLEMODULE_[name]=true

You can disable a module when you start the instance:

```bash
docker run -e DISABLEMODULE_DOM=true -e DISABLEMODULE_XSL=true byjg/php:7.2-cli
```

## VERBOSE=true

When you pass `VERBOSE=true` you can get at output all available modules 
and which modules are disabled.

```bash
docker run -e VERBOSE=true byjg/php:7.2-cli
```


