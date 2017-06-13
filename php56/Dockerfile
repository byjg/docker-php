FROM php:5-alpine

MAINTAINER Joao Gilberto Magalhaes

RUN docker-php-ext-install \
    exif \
    mbstring \
    mysqli \
    pdo_mysql \
    pcntl

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
&& pecl install -o -f redis-2.2.8 \
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
&& pecl install memcached-2.2.0 \
&& docker-php-ext-enable memcached \
&& apk del --no-cache autoconf gcc g++ make zlib-dev cyrus-sasl-dev

# Install Xsl
RUN apk add --no-cache libxslt libxslt-dev \
&& docker-php-ext-install xsl \
&& apk del --no-cache libxslt-dev

# Install PDO Postgres
RUN apk add --no-cache libpq postgresql-dev \
&& docker-php-ext-install pdo_pgsql \
&& apk del --no-cache postgresql-dev

# Install PDO DbLib
RUN apk add --no-cache freetds freetds-dev \
&& docker-php-ext-install pdo_dblib \
&& apk del --no-cache freetds-dev

# Install MongoDB
RUN apk add --no-cache autoconf gcc g++ make openssl-dev \
&& pecl install mongodb \
&& docker-php-ext-enable mongodb \
&& apk del --no-cache autoconf gcc g++ make openssl-dev

# Install Zip
RUN apk add --no-cache zlib zlib-dev \
&& docker-php-ext-install zip \
&& apk del --no-cache zlib-dev

# Install Soap
RUN apk add --no-cache libxml2 libxml2-dev \
&& docker-php-ext-install dom soap \
&& apk del --no-cache libxml2-dev



# Install Other Dependencies
RUN apk add --no-cache git openssh-client


# Install Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
&& php composer-setup.php \
&& php -r "unlink('composer-setup.php');" \
&& mv composer.phar /usr/local/bin/composer

# Install PHPUnit
RUN COMPOSER_HOME="/opt/.composer" composer global require "phpunit/phpunit=4.7.*" \
&& ln -s /opt/.composer/vendor/bin/phpunit /usr/local/bin/

RUN COMPOSER_HOME="/opt/.composer" composer global require "squizlabs/php_codesniffer=*" \
&& ln -s /opt/.composer/vendor/bin/phpcs /usr/local/bin/ \
&& ln -s /opt/.composer/vendor/bin/phpcbf /usr/local/bin/

RUN COMPOSER_HOME=/opt/.composer composer global require "phpmd/phpmd:@stable" \
&& ln -s /opt/.composer/vendor/bin/phpmd /usr/local/bin/
