#!/usr/bin/env bash

if [ -z "$1" ]
then
    echo ""
    echo "build.sh <VERSION e.g 7.2> [DOCKERLOGIN] [DOCKERPASSWORD] [REGISTRY]"
    echo ""
    exit 1
fi

if [ ! -z "$3" ]
then
    docker login --username "$2" --password "$3" "$4"
    if [[ $? -ne 0 ]]; then
        echo "Error"
        exit 1
    fi
fi

if [ ! -f "Dockerfile-$1-cli" ]
then
    echo "Does not exists $1"
    exit 1
fi


#docker rmi byjg/php:$1-base
docker build -t byjg/php:$1-base -f Dockerfile-$1-base .
if [[ $? -ne 0 ]]; then
    echo "Error"
    exit 1
fi
if [ ! -z "$3" ]; then docker push byjg/php:$1-base; fi

#docker rmi byjg/php:$1-cli
docker build -t byjg/php:$1-cli -f Dockerfile-$1-cli .
if [[ $? -ne 0 ]]; then
    echo "Error"
    exit 1
fi
if [ ! -z "$3" ]; then docker push byjg/php:$1-cli; fi

#docker rmi byjg/php:$1-fpm
docker build -t byjg/php:$1-fpm -f Dockerfile-$1-fpm .
if [[ $? -ne 0 ]]; then
    echo "Error"
    exit 1
fi
if [ ! -z "$3" ]; then docker push byjg/php:$1-fpm; fi

#docker rmi byjg/php:$1-fpm-nginx
docker build -t byjg/php:$1-fpm-nginx -f Dockerfile-$1-fpm-nginx .
if [[ $? -ne 0 ]]; then
    echo "Error"
    exit 1
fi
if [ ! -z "$3" ]; then docker push byjg/php:$1-fpm-nginx; fi
