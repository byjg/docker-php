# Docker PHP 5.6 Cli with MySQL Server 5.6

A Docker image with PHP 5.6 Cli and MySQL Server 5.6. The main purpose is to be create an environment for Bitbucket Pipelines where it is possible to run PHP and have the MySQL for running unit tests with migration. 

This package contains:

- PHP 5.6 Cli (with extensions Json, Xml, Curl, PDO MySQL)
- MySQL Server 5.6
- PHPUnit 4.7
- ByJG Migrate

# Build

```
export VERSION=1.0.0
docker build -t byjg/docker-php56-mysql:${VERSION} .
docker tag byjg/docker-php56-mysql:${VERSION} byjg/docker-php56-mysql:latest
docker login
docker push byjg/docker-php56-mysql:${VERSION}
docker push byjg/docker-php56-mysql:latest
```

# Using this docker as your default CLI

This image extends the "byjg/docker-php56" and you can create alias for PHP and PHPUnit like below:

```
alias php="docker run -it --rm --name byjg-php56-php byjg/php56-mysql php"
alias phpunit="docker run -it --rm --name byjg-php56-phpunit byjg/php56-mysql phpunit"
alias migrate="docker run -it --rm --name byjg-php56-migrate byjg/php56-mysql migrate"
alias composer="docker run -it --rm --name byjg-php56-composer byjg/php56-mysql composer"
```

If you want to attach this to bitbucket pipelines, create the file `bitbucket-pipelines.yml` and put:

```
image: byjg/docker-php56-mysql:latest

pipelines:
  default:
    - step:
        script: # Modify the commands below to build your repository.
          - service mysql start
          - composer install
          - phpunit
``` 

