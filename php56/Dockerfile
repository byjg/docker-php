FROM ubuntu:14.04

MAINTAINER Joao Gilberto Magalhaes

# Update Repository
RUN apt-get update

# Add the Ondrej PPA Repository
RUN apt-get install -y software-properties-common
RUN apt-get install -y language-pack-en-base
RUN export LC_ALL=en_US.UTF-8 && export LANG=en_US.UTF-8 && add-apt-repository -y ppa:ondrej/php
RUN apt-get update

# Install PHP56
RUN apt-get install -y php5.6 php5.6-curl php5.6-xml php5.6-json

# Install Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php -r "if (hash_file('SHA384', 'composer-setup.php') === 'aa96f26c2b67226a324c27919f1eb05f21c248b987e6195cad9690d5c1ff713d53020a02ac8c217dbf90a7eacc9d141d') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
RUN php composer-setup.php
RUN php -r "unlink('composer-setup.php');"
RUN mv composer.phar /usr/local/bin/composer

# Install Dependences for Composer
RUN apt-get -y install git unzip

# Install PHPUnit
RUN composer global require "phpunit/phpunit=4.7.*"
RUN ln -s /root/.composer/vendor/bin/phpunit /usr/local/bin/

# Install Migration ByJG
RUN composer global require "byjg/migration=1.0.*"
RUN ln -s /root/.composer/vendor/bin/migrate /usr/local/bin/


