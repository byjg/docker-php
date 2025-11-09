---
sidebar_position: 1
---

# PHP "*-base" Image

All `*-base` images are based on Alpine Linux and include only the necessary layers. Because of this, the images are tiny and very optimized.

## Features

### Pre-installed PHP Extensions (45+)

All base images come with over 45 PHP extensions pre-installed:

<details>
<summary>Click to view all extensions</summary>

```
bcmath, Core, ctype, curl, date, dba, dom, exif, fileinfo, filter, ftp, gd, gettext,
hash, iconv, igbinary, intl, json, libxml, mbstring, mcrypt, memcached, mongodb,
mysqli, mysqlnd, openssl, pcntl, pcre, PDO, pdo_dblib, pdo_mysql, pdo_pgsql,
pdo_sqlite, Phar, posix, readline, redis, Reflection, session, shmop, SimpleXML,
soap, sockets, SPL, sqlite3, standard, tokenizer, xdebug, xml, xmlreader, xmlwriter,
xsl, yaml, zip, zlib
```

</details>

### Additional Tools

- **[Composer](https://getcomposer.org/)** - Latest version included

## Usage

### Basic Usage

```bash
docker run -it --rm byjg/php:8.3-base php --version
```

### Running PHP Scripts

```bash
docker run -v $PWD:/workdir -w /workdir byjg/php:8.3-base php script.php
```

## Exposed Ports

| Port | Purpose |
|------|---------|
| 9001 | XDebug  |

## Customization

### Adding Custom PHP Configuration

You can add custom PHP configuration by mounting `.ini` files to `/etc/php/conf.d`:

```bash
docker run -v $PWD/custom.ini:/etc/php/conf.d/custom.ini byjg/php:8.3-base
```
