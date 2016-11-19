FROM ubuntu:16.04

MAINTAINER Joao Gilberto Magalhaes

# Install PHP7 (Ubuntu Native)
RUN apt-get update
RUN apt-get install -y php7.0 php7.0-curl php7.0-xml php7.0-json

# Install Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php -r "if (hash_file('SHA384', 'composer-setup.php') === 'aa96f26c2b67226a324c27919f1eb05f21c248b987e6195cad9690d5c1ff713d53020a02ac8c217dbf90a7eacc9d141d') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
RUN php composer-setup.php
RUN php -r "unlink('composer-setup.php');"
RUN mv composer.phar /usr/local/bin/composer

# Install Dependences for Composer
RUN apt-get -y install git unzip

# Install PHPUnit
RUN composer global require "phpunit/phpunit=5.2.*"
RUN ln -s /root/.composer/vendor/bin/phpunit /usr/local/bin/

# Install Migration ByJG
RUN composer global require "byjg/migration=1.0.*"
RUN ln -s /root/.composer/vendor/bin/migrate /usr/local/bin/



