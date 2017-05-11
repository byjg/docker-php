FROM php:7-fpm

MAINTAINER Joao Gilberto Magalhaes

RUN apt-get -y update

RUN docker-php-ext-install \
    exif \
    mbstring \
    mysqli \
    pdo_mysql \
    pcntl

RUN apt-get install -y libfreetype6-dev libpng-dev libgd-dev libjpeg62-turbo-dev  \
&& docker-php-ext-configure gd \
    --with-gd \
    --with-freetype-dir=/usr/include/ \
    --with-png-dir=/usr/include/ \
    --with-jpeg-dir=/usr/include/  \
&& NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) \
&& docker-php-ext-install -j${NPROC} gd

RUN apt-get install -y libicu-dev \
&& docker-php-ext-install intl

RUN apt-get install -y libmcrypt-dev \
&& docker-php-ext-install mcrypt

# Install Redis
RUN pecl install -o -f redis \
&& rm -rf /tmp/pear \
&& docker-php-ext-enable redis \
&& apt-get remove -y build-essential && apt-get autoremove && apt-get clean

# Install XDebug
RUN pecl install xdebug \
&& docker-php-ext-enable xdebug \
&& echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
&& echo "xdebug.remote_autostart=off" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
&& echo "xdebug.remote_connect_back=on" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
&& echo "xdebug.remote_port=9001" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# Install memcached
RUN apt-get install -y libmemcached-dev \
&& curl -L -o /tmp/memcached.tar.gz "https://github.com/php-memcached-dev/php-memcached/archive/php7.tar.gz" && \
   mkdir -p memcached && \
   tar -C memcached -zxvf /tmp/memcached.tar.gz --strip 1 && \
   ( \
       cd memcached && \
       phpize && \
       ./configure && \
       make -j$(nproc) && \
       make install \
   ) && \
   rm -r memcached && \
   rm /tmp/memcached.tar.gz \
&& docker-php-ext-enable memcached

# Install Xsl
RUN apt-get install -y libxslt1.1 libxslt1-dev \
&& docker-php-ext-install xsl

# Install PDO Postgres
RUN apt-get install -y libpq5 libpq-dev \
&& docker-php-ext-install pdo_pgsql

# Install PDO DbLib
RUN apt-get install -y libdbd-freetds libsybdb5 freetds-dev \
&& ln -s /usr/lib/x86_64-linux-gnu/libsybdb.a /usr/lib/ \
&& docker-php-ext-install pdo_dblib

# Install MongoDB
RUN pecl install mongodb \
&& docker-php-ext-enable mongodb

# Install Zip
RUN apt-get install -y zlib1g-dev \
&& docker-php-ext-install zip

# Install Soap
RUN apt-get install -y libxml2-dev \
&& docker-php-ext-install dom soap



# Install Other Dependencies
RUN apt-get install -y git openssh-client


# Install Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
&& php composer-setup.php \
&& php -r "unlink('composer-setup.php');" \
&& mv composer.phar /usr/local/bin/composer



