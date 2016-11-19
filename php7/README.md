# Docker PHP 7.0 Cli

An Docker image with PHP 7.0 Cli. This package contains:

- PHP 7.0 Cli (with extensions Json, Xml, Curl)
- PHPUnit 5.2
- ByJG Migrate

# Build

```
export VERSION=1.0.0
docker build -t byjg/docker-php7:${VERSION} .
docker tag byjg/docker-php7:${VERSION} byjg/docker-php7:latest
docker login
docker push byjg/docker-php7:${VERSION}
docker push byjg/docker-php7:latest
```

# Using this docker as your default CLI

```
alias php="docker run -it --rm --name byjg-php7-php byjg/docker-php7 php"
alias phpunit="docker run -it --rm --name byjg-php7-phpunit byjg/docker-php7 phpunit"
alias migrate="docker run -it --rm --name byjg-php7-migrate byjg/docker-php7 migrate"
alias composer="docker run -it --rm --name byjg-php7-composer byjg/docker-php7 composer"
```


