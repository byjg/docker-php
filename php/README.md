# Docker ByJG PHP Images

The Docker ByJG PHP Images has several bundled images based on PHP in different versions.

This images is ready to use in:
 - Development Environment
 - Production Environment
 - CI/CD environments (like Bitbucket Pipelines, Travis-Ci, and others)

### Supported Tags

- 7.2-cli
- 7.2-fpm
- 7.2-fpm-nginx
- 7.1-cli
- 7.1-fpm
- 7.1-fpm-nginx
- 7.0-cli
- 7.0-fpm
- 7.0-fpm-nginx
- 5.6-cli
- 5.6-fpm
- 5.6-fpm-nginx

### Content of this Images

All images are based on Alpine Linux and have less layers can be possible.

Because this the images are tiny and very optimized.

In all images you can found:

- PHP
- Composer
- ctype
- curl
- date
- dom
- exif
- fileinfo
- filter
- ftp
- gd
- gettext
- hash
- iconv
- intl
- json
- libxml
- mbstring
- mcrypt
- memcached
- mongodb
- mysqli
- mysqlnd
- openssl
- pcntl
- pcre
- PDO
- pdo_dblib
- pdo_mysql
- pdo_pgsql
- pdo_sqlite
- Phar
- posix
- readline
- redis
- Reflection
- session
- SimpleXML
- soap
- SPL
- sqlite3
- standard
- tokenizer
- xdebug
- xml
- xmlreader
- xmlwriter
- xsl
- zip
- zlib
- Xdebug

#### Specific for CLI Images

The CLI images have also:

- phpunit
- phpcs
- phpcbf
- phpmd

You can use the Command Line programs by typing:

```bash
docker run \
    -it --rm --name byjgcli \
    -v "$PWD":/usr/src/myapp \
    -w /usr/src/myapp \
    -u $UID:${GROUPS[0]} \ 
    byjg/php:7-cli \ 
    php  # <-- you can put here phpunit, phpmd, phpcs, phpcbf
```


#### Specifig for FPM Images

The FPM images have installed the modules PHP-FPM.

This exposes two ports:
- 9000 for the FPM
- 9001 for the XDebug

#### Specifig for FPM-NGINX Images

The FPM-NGINX have a full featured LEMP Server (without mysql bundled).

This exposes the ports 80, 443 and 9001 (XDebug)

The home directory is in /srv/web.

Basically to start type:

```bash
docker run \
    -v /path/to/project:/srv/web
    -p 80:80 \
    byjg/php:7-fpm-nginx
```

By default all files in /srv/web is served.
 
You can set your own FPM configurations by attaching a volume to:
- /etc/nginx/nginx.conf
- /etc/nginx/conf.d/default.conf


