FROM byjg/php56:alpine

MAINTAINER Joao Gilberto Magalhaes

RUN apk add --no-cache mysql mysql-client

RUN /usr/bin/mysql_install_db --user=mysql

#RUN /etc/init.d/mariadb start && rc-update add mariadb default
#RUN /usr/bin/mysqladmin -u root password 'password'