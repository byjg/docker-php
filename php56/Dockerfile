FROM alpine:3.4

MAINTAINER Joao Gilberto Magalhaes

# Update Repository
RUN apk update
RUN apk add \
	--no-cache -v \
	--repository http://dl-cdn.alpinelinux.org/alpine/edge/main \
	php5-cli php5-curl php5-xml php5-json php5-gd php5-memcache php5-shmop \
	php5-mysql php5-pdo php5-xsl php5-dom php5-iconv php5-mcrypt php5-openssl \
	php5-phar php5-pdo_mysql

# Install Dependences for Composer
RUN apk add git unzip

# Install Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php -r "if (hash_file('SHA384', 'composer-setup.php') === 'aa96f26c2b67226a324c27919f1eb05f21c248b987e6195cad9690d5c1ff713d53020a02ac8c217dbf90a7eacc9d141d') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
RUN php composer-setup.php
RUN php -r "unlink('composer-setup.php');"
RUN mv composer.phar /usr/local/bin/composer

# Install PHPUnit
RUN composer global require "phpunit/phpunit=4.7.*"
RUN ln -s /root/.composer/vendor/bin/phpunit /usr/local/bin/

# Install Migration ByJG
RUN composer global require "byjg/migration=1.0.*"
RUN ln -s /root/.composer/vendor/bin/migrate /usr/local/bin/


