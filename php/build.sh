#!/usr/bin/env bash

set +e

if [[ -z "$1" ]]
then
    echo ""
    echo "build.sh <VERSION e.g 7.2> [DOCKERLOGIN] [DOCKERPASSWORD] [REGISTRY]"
    echo ""
    exit 1
fi

if [[ ! -z "$3" ]]
then
    docker login --username "$2" --password "$3" "$4"
    if [[ $? -ne 0 ]]; then
        echo "Error"
        exit 1
    fi
fi

LIST="$1-base $1-cli $1-fpm $1-fpm-nginx $1-fpm-apache"

for item in $LIST
do
    arch=".amd64"
    if [ ! -z "$TRAVIS_CPU_ARCH" ];
    then
      arch=".$TRAVIS_CPU_ARCH"
    fi
    #docker rmi byjg/php:$1-base
    echo "====================================================="
    echo " Starting: byjg/php:${item}"
    echo "====================================================="

    docker build -t byjg/php:${item}{$arch} -f Dockerfile-${item} .
    if [[ $? -ne 0 ]]; then
        echo "Error"
        exit 1
    fi

    if [[ ! -z "$3" ]]
    then
        docker push byjg/php:${item}{$arch}

        if [[ ! -z "${TRAVIS_BUILD_NUMBER}" ]]
        then
            docker tag byjg/php:${item}{$arch} byjg/php:${item}.${TRAVIS_BUILD_NUMBER}{$arch}
            docker push byjg/php:${item}.${TRAVIS_BUILD_NUMBER}{$arch}
        fi
    fi
done
