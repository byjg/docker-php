# Docker PHP 5.6 Cli

An Docker image with PHP 5.6 Cli. This package contains:

- PHP 5.6 Cli (with extensions Json, Xml, Curl)
- PHPUnit 4.7
- ByJG Migrate

# Build

```
export VERSION=1.0.0
docker build -t byjg/docker-php56:${VERSION} .
docker tag byjg/docker-php56:${VERSION} byjg/docker-php56:latest
docker login
docker push byjg/docker-php56:${VERSION}
docker push byjg/docker-php56:latest
```

# Using this docker as your default CLI

```
alias php="docker run -it --rm --name byjg-php56-php byjg/php56 php"
alias phpunit="docker run -it --rm --name byjg-php56-phpunit byjg/php56 phpunit"
alias migrate="docker run -it --rm --name byjg-php56-migrate byjg/php56 migrate"
alias composer="docker run -it --rm --name byjg-php56-composer byjg/php56 composer"
```


