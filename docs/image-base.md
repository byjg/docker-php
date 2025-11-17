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
- **vim** - Text editor for file editing within containers
- **git** - Version control system
- **bash** - Enhanced shell

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

## Security

### Non-Root User

All images run as a non-root user (`app`) for enhanced security. This follows container security best practices by limiting potential damage from container breakouts.

**User Details:**
- **Username:** `app`
- **Group:** `app`
- **Home Directory:** `/srv`

### Permission Considerations

When mounting volumes, ensure the non-root user has appropriate permissions:

```bash
# Option 1: Set ownership on host
chown -R 1000:1000 /path/to/your/project

# Option 2: Run container with user option (less secure)
docker run --user root byjg/php:8.3-base

# Option 3: Mount with appropriate permissions
docker run -v $PWD:/srv:rw byjg/php:8.3-base
```

:::warning
Running as root (`--user root`) defeats the security benefits of non-root containers. Only use this for debugging or when absolutely necessary.
:::

### Installing Additional Packages

If you need to install additional packages in a derived Dockerfile, temporarily switch to root:

```dockerfile
FROM byjg/php:8.3-base

USER root
RUN apk add --no-cache additional-package
USER app

# Your application code
COPY --chown=app:app . /srv
```

## Customization

### Adding Custom PHP Configuration

You can add custom PHP configuration by mounting `.ini` files to `/etc/php/conf.d`:

```bash
docker run -v $PWD/custom.ini:/etc/php/conf.d/custom.ini byjg/php:8.3-base
```
