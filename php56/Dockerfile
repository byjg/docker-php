FROM php:5-alpine

MAINTAINER Joao Gilberto Magalhaes

RUN apk add --no-cache --virtual .build autoconf gcc g++ make bash \
 && apk add --no-cache --virtual .gd freetype libpng libjpeg-turbo freetype-dev libpng-dev libjpeg-turbo-dev \
 && apk add --no-cache --virtual .icu icu-dev \
 && apk add --no-cache --virtual .mcrypt libmcrypt-dev \
 && apk add --no-cache --virtual .memcached libmemcached zlib cyrus-sasl libmemcached-dev zlib-dev cyrus-sasl-dev \
 && apk add --no-cache --virtual .xslt libxslt libxslt-dev \
 && apk add --no-cache --virtual .postgres libpq postgresql-dev \
 && apk add --no-cache --virtual .freetds freetds freetds-dev \
 && apk add --no-cache --virtual .mongodb openssl-dev pcre-dev \
 && apk add --no-cache --virtual .zlib zlib zlib-dev \
 && apk add --no-cache --virtual .xml libxml2 libxml2-dev \
 && apk add --no-cache --virtual .gettext gettext-dev \
 && NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) \
 && docker-php-ext-configure gd \
    --with-gd \
    --with-freetype-dir=/usr/include/ \
    --with-png-dir=/usr/include/ \
    --with-jpeg-dir=/usr/include/  \
 && docker-php-ext-install -j${NPROC} \
        exif \
        mbstring \
        mysql \
        mysqli \
        pdo_mysql \
        pcntl \
        intl \
        mcrypt \
        xsl \
        pdo_pgsql \
        pdo_dblib \
        zip \
        dom \
        soap \
        gd \
        gettext \
 && echo ==Redis== \
 && pecl install -o -f redis-2.2.8 \
 && rm -rf /tmp/pear \
 && docker-php-ext-enable redis \
 && echo ==XDebug==  \
 && pecl install xdebug \
 && docker-php-ext-enable xdebug \
 && echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
 && echo "xdebug.remote_autostart=off" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
 && echo "xdebug.remote_connect_back=on" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
 && echo "xdebug.remote_port=9001" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
 && echo ==Memcached==  \
 && pecl install memcached-2.2.0 \
 && docker-php-ext-enable memcached \
 && echo ==MongoDb==  \
 && /bin/bash -lc "pecl install mongodb" \
 && docker-php-ext-enable mongodb \
 && echo ==Other Dependencies==  \
 && apk add --no-cache git openssh-client \
 && apk del .build


# Install Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
 && php composer-setup.php \
 && php -r "unlink('composer-setup.php');" \
 && mv composer.phar /usr/local/bin/composer \
 && COMPOSER_HOME="/opt/.composer" \
    composer global require \
        "phpunit/phpunit=4.7.*" \
        "squizlabs/php_codesniffer=*" \
        "phpmd/phpmd:@stable" \
 && ln -s /opt/.composer/vendor/bin/phpunit /usr/local/bin/ \
 && ln -s /opt/.composer/vendor/bin/phpcs /usr/local/bin/ \
 && ln -s /opt/.composer/vendor/bin/phpcbf /usr/local/bin/ \
 && ln -s /opt/.composer/vendor/bin/phpmd /usr/local/bin/
