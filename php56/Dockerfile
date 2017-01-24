FROM php:5.6.28

MAINTAINER Joao Gilberto Magalhaes

# Install Composer Dependencies
RUN apt-get -y update \
&& apt-get -y install git unzip

# Valuable Extensions
RUN apt-get install -y libicu-dev \
&& docker-php-ext-install intl

RUN apt-get install -y libxml2-dev \
&& docker-php-ext-install dom

RUN apt-get install -y libfreetype6-dev libgd-dev \
&& docker-php-ext-configure gd --with-freetype-dir=/usr \
&& docker-php-ext-install gd exif

RUN docker-php-ext-install mysql mysqli pdo pdo_mysql

RUN apt-get install -y libmcrypt-dev \
&& docker-php-ext-install mcrypt

# Install XDebug
RUN pecl install xdebug \
&& docker-php-ext-enable xdebug \
&& echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
&& echo "xdebug.remote_autostart=off" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
&& echo "xdebug.remote_connect_back=on" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
&& echo "xdebug.remote_port=9001" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# Install Redis
RUN pecl install -o -f redis-2.2.8 \
&& rm -rf /tmp/pear \
&& docker-php-ext-enable redis

# Install memcached
RUN apt-get install -y libmemcached-dev \
&& pecl install memcached \
&& docker-php-ext-enable memcached



# Install Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
&& php composer-setup.php \
&& php -r "unlink('composer-setup.php');" \
&& mv composer.phar /usr/local/bin/composer

# Install PHPUnit
RUN COMPOSER_HOME="/opt/.composer" composer global require "phpunit/phpunit=4.7.*" \
&& ln -s /opt/.composer/vendor/bin/phpunit /usr/local/bin/

# Install Migration ByJG
RUN COMPOSER_HOME="/opt/.composer" composer global require "byjg/migration=1.0.*" \
&& ln -s /opt/.composer/vendor/bin/migrate /usr/local/bin/

# Install Daemonize ByJG
RUN COMPOSER_HOME="/opt/.composer" composer global require "byjg/php-daemonize=1.2.*" \
&& ln -s /opt/.composer/vendor/bin/daemonize /usr/local/bin/

RUN COMPOSER_HOME="/opt/.composer" composer global require "squizlabs/php_codesniffer=*" \
&& ln -s /opt/.composer/vendor/bin/phpcs /usr/local/bin/ \
&& ln -s /opt/.composer/vendor/bin/phpcbf /usr/local/bin/

RUN COMPOSER_HOME=/opt/.composer composer global require "phpmd/phpmd:@stable" \
&& ln -s /opt/.composer/vendor/bin/phpmd /usr/local/bin/

# Clear all unnecessary files
RUN apt-get autoremove -y \
&& apt-get clean all

