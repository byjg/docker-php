# PHP "*-base" Image

All "*-base" images are based on Alpine Linux and only the necessary layers. Because of that the images
are tiny and very optimized.

You can find more than 45 extensions pre-installed in all images:

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

### Adding Custom Config

You can create a volume or copy all *.ini files to `/etc/php/conf.d`
