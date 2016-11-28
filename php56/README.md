# Docker PHP 5.6 Cli

An Docker image with PHP 5.6 Cli. This package is intended to be use for 
development environment an has been setup for PHPStorm as Remote Interpreter
ora single command line. 

This package contains:

- PHP 5.6 Cli
- Composer
- PHPUnit 4.7
- ByJG Migrate
- ByJG PHP Daemonize
- PHP Code Sniffer
- PHP Mess Detector
- PHP Modules: Core, ctype, curl, date, dom, ereg, exif, fileinfo, filter,
ftp, gd, hash, iconv, intl, json, libxml, mbstring, mcrypt, mysql, mysqli
mysqlnd, openssl, pcre, PDO, pdo_mysql, pdo_sqlite, Phar, posix, readline,
redis, Reflection, session, SimpleXML, SPL, sqlite3, standard, tokenizer,
xdebug, xml, xmlreader, xmlwriter, zlib, Xdebug (Port 9001)

# Build

```
export VERSION=1.0.0
docker build -t byjg/php56:${VERSION} .
docker tag byjg/php56:${VERSION} byjg/docker-php56:latest
docker login
docker push byjg/php56:${VERSION}
docker push byjg/php56:latest
```

# Using this docker as your default CLI

```
alias php='docker run -it --rm --name byjg-php56-php -v "$PWD":/usr/src/myapp -w /usr/src/myapp -u $UID:${GROUPS[0]} byjg/php56 php'
alias phpunit='docker run -it --rm --name byjg-php56-phpunit -v "$PWD":/usr/src/myapp -w /usr/src/myapp -u $UID:${GROUPS[0]}  byjg/php56 phpunit'
alias composer='mkdir -p $HOME/.composer && docker run -it --rm --name byjg-php56-composer -v "$PWD":/usr/src/myapp -v "$HOME/.composer":/.composer -w /usr/src/myapp -u $UID:${GROUPS[0]}  byjg/php56 composer'
alias migrate='docker run -it --rm --name byjg-php56-migrate -v "$PWD":/usr/src/myapp -w /usr/src/myapp -u $UID:${GROUPS[0]}  byjg/php56 migrate'
```


