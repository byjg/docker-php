#!/usr/bin/env bash

# Usage:
# source ./php-from-docker.sh <version>

if [ -z "$1" ]; then
  echo Usage:
  echo source "$0" \<version\>
  exit 1
fi

export PHP_VERSION="$1"

docker pull byjg/php:"${PHP_VERSION}"-cli

alias php='docker run -it --rm -v "$PWD":/workdir -w /workdir -u $(id -u):$(id -g) -p 9001:9001 byjg/php:${PHP_VERSION}-cli php'
alias composer='docker run -it --rm -v "$PWD":/workdir -v "$HOME/.composer:/.composer" -w /workdir -u $(id -u):$(id -g) byjg/php:${PHP_VERSION}-cli composer'
