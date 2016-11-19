FROM byjg/php56:latest

MAINTAINER Joao Gilberto Magalhaes

RUN echo 'mysql-server-5.6 mysql-server/root_password password password' | debconf-set-selections
RUN echo 'mysql-server-5.6 mysql-server/root_password_again password password' |debconf-set-selections
RUN apt-get install -y mysql-server-5.6 php5.6-mysql

