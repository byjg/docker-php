FROM php:7-fpm

MAINTAINER Joao Gilberto Magalhaes

# Install Composer Dependencies
RUN apt-get -y update && \
    apt-get -y install git unzip

# Valuable Extensions
RUN apt-get install -y libicu-dev && docker-php-ext-install intl

RUN apt-get install -y libxml2-dev && docker-php-ext-install dom

RUN apt-get install -y libfreetype6-dev libgd-dev && \
    docker-php-ext-configure gd --with-freetype-dir=/usr && \
    docker-php-ext-install gd exif

RUN docker-php-ext-install mysqli pdo pdo_mysql

RUN apt-get install -y libmcrypt-dev && \
    docker-php-ext-install mcrypt

# Install XDebug
RUN pecl install xdebug && \
    docker-php-ext-enable xdebug

# Install Redis
RUN pecl install -o -f redis \
&&  rm -rf /tmp/pear \
&&  echo "extension=redis.so" > /usr/local/etc/php/conf.d/docker-php-ext-redis.ini

EXPOSE 9000

# Clear all unnecessary files
RUN apt-get autoremove -y && apt-get clean all

