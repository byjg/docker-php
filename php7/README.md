# Docker PHP 7.0 Cli

An Docker image with PHP 7.0 Cli. This package contains:

- PHP 7.0 Cli (with extensions Json, Xml, Curl)
- PHPUnit 5.2
- ByJG Migrate

# Build

```
export VERSION=1.0.0
docker build -t byjg/php7:${VERSION} .
docker tag byjg/php7:${VERSION} byjg/docker-php7:latest
docker login
docker push byjg/php7:${VERSION}
docker push byjg/php7:latest
```

# Using this docker as your default CLI

```
alias php='docker run -it --rm --name byjg-php7-php -v "$PWD":/usr/src/myapp -w /usr/src/myapp -u $UID:${GROUPS[0]} byjg/php7 php'
alias phpunit='docker run -it --rm --name byjg-php7-phpunit -v "$PWD":/usr/src/myapp -w /usr/src/myapp -u $UID:${GROUPS[0]}  byjg/php7 phpunit'
alias composer='mkdir -p $HOME/.composer && docker run -it --rm --name byjg-php7-composer -v "$PWD":/usr/src/myapp -v "$HOME/.composer":/.composer -w /usr/src/myapp -u $UID:${GROUPS[0]}  byjg/php7 composer'
alias migrate='docker run -it --rm --name byjg-php7-migrate -v "$PWD":/usr/src/myapp -w /usr/src/myapp -u $UID:${GROUPS[0]}  byjg/php7 migrate'
```


