FROM byjg/docker-php56:latest

RUN echo 'mysql-server-5.6 mysql-server/root_password password password' | debconf-set-selections
RUN echo 'mysql-server-5.6 mysql-server/root_password_again password password' |debconf-set-selections
RUN apt-get install -y mysql-server-5.6
RUN apt-get install -y php5.6-mysql

