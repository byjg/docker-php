FROM php:5-fpm-alpine

MAINTAINER Joao Gilberto Magalhaes

RUN docker-php-ext-install \
    exif \
    mbstring \
    mysqli \
    pdo_mysql

RUN apk add --no-cache freetype libpng libjpeg-turbo freetype-dev libpng-dev libjpeg-turbo-dev \
&& docker-php-ext-configure gd \
    --with-gd \
    --with-freetype-dir=/usr/include/ \
    --with-png-dir=/usr/include/ \
    --with-jpeg-dir=/usr/include/  \
&& NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) \
&& docker-php-ext-install -j${NPROC} gd  \
&& apk del --no-cache freetype-dev libpng-dev libjpeg-turbo-dev

RUN apk add --no-cache icu-dev \
&& docker-php-ext-install intl

RUN apk add --no-cache libmcrypt-dev \
&& docker-php-ext-install mcrypt

# Install Redis
RUN apk add --no-cache autoconf gcc g++ make \
&& pecl install -o -f redis \
&& rm -rf /tmp/pear \
&& docker-php-ext-enable redis \
&& apk del --no-cache autoconf gcc g++ make

# Install XDebug
RUN apk add --no-cache autoconf gcc g++ make \
&& pecl install xdebug \
&& docker-php-ext-enable xdebug \
&& echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
&& echo "xdebug.remote_autostart=off" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
&& echo "xdebug.remote_connect_back=on" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
&& echo "xdebug.remote_port=9001" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
&& apk del --no-cache autoconf gcc g++ make

# Install memcached
RUN apk add --no-cache libmemcached-dev autoconf gcc g++ make zlib-dev cyrus-sasl-dev cyrus-sasl zlib  \
&& pecl install memcached \
&& docker-php-ext-enable memcached \
&& apk del --no-cache autoconf gcc g++ make zlib-dev cyrus-sasl-dev

RUN apk add --no-cache git


# Install Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
&& php composer-setup.php \
&& php -r "unlink('composer-setup.php');" \
&& mv composer.phar /usr/local/bin/composer

EXPOSE 9000

