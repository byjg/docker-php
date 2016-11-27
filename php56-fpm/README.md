# Docker PHP 5.6 with FPM

A Ready to use PHP 5.6 client with FPM and XDebug. 

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


