#!/usr/bin/env bash

# Setting if is verbose mode or not
VERBOSE_MODE=false
if [ "$VERBOSE" == "true" ]
then
    VERBOSE_MODE=true
    echo
    echo " ____             _  _____ "
    echo "|  _ \           | |/ ____|"
    echo "| |_) |_   _     | | |  __ "
    echo "|  _ <| | | |_   | | | |_ |"
    echo "| |_) | |_| | |__| | |__| |"
    echo "|____/ \__, |\____/ \_____|"
    echo "        __/ |              "
    echo "       |___/               "
    echo
    echo "Image: $DOCKER_IMAGE"
    echo "Build Date: `cat /etc/build-date`"
    echo
fi

if [ -z "$PHP_FPM_SERVER" ]
then
  PHP_FPM_SERVER=127.0.0.1:9000
fi

# Adjust NGINX
if [[ -f /etc/nginx/http.d/default.conf ]]
then
  if [ -z "$NGINX_ROOT" ]
  then
    NGINX_ROOT=/var/www/html
  fi

  ${VERBOSE_MODE} && echo "Setting root to '$NGINX_ROOT'"
  sed -i "s|^\(\s*root\s*\)@root@;$|\1$NGINX_ROOT;|g" /etc/nginx/http.d/default.conf
  ${VERBOSE_MODE} && echo "Setting NGINX fastcgi to '$PHP_FPM_SERVER'"
  sed -i "s|@fastcgi@|${PHP_FPM_SERVER}|g" /etc/nginx/http.d/default.conf

  if [[ -n "$PHP_CONTROLLER" ]]
  then
      ${VERBOSE_MODE} && echo "Setting controller as '$PHP_CONTROLLER'"
      sed -i "s|^\(\s*\)#\(try_files.*\)@controller@\(.*\);$|\1\2$PHP_CONTROLLER\3;|g" /etc/nginx/http.d/default.conf
      sed -i "s|^\(\s*\)\(index index.php.*\)$|\1#\2|g" /etc/nginx/http.d/default.conf
  fi

  if [[ -n "$NGINX_SSL_CERT" ]]
  then
      ${VERBOSE_MODE} && echo "Setting CERT as '$NGINX_SSL_CERT'"
      ${VERBOSE_MODE} && echo "Setting CERT_KEY as '$NGINX_SSL_CERT_KEY'"
      sed -i "s|^\(\s*\)#\(listen 443.*\)$|\1\2|g" /etc/nginx/http.d/default.conf
      sed -i "s|^\(\s*\)#\(ssl_certificate .*\)@cert@;$|\1\2$NGINX_SSL_CERT;|g" /etc/nginx/http.d/default.conf
      sed -i "s|^\(\s*\)#\(ssl_certificate_key .*\)@certkey@;$|\1\2$NGINX_SSL_CERT_KEY;|g" /etc/nginx/http.d/default.conf
  fi
fi

# Adjust PHP
if [[ -f /usr/bin/php ]]
then
  # Getting PHP INI Paths
  PHPINI=`php -i | grep "Loaded Configuration File" | awk -F" => " '{print $2}'`
  PHPMODULES=`php -i | grep "Scan this dir" |  awk -F" => " '{print $2}'`
  PHPCUSTOM=/etc/php/conf.d
  PHPWWWCONFPATH=$(find /etc -name www.conf 2>/dev/null)

  if [ -f "$PHPWWWCONFPATH" ]
  then
      ${VERBOSE_MODE} && echo "Setting FPM fastcgi to '$PHP_FPM_SERVER'"
      sed -i "s|@fastcgi@|${PHP_FPM_SERVER}|g" $PHPWWWCONFPATH
  fi

  # Disable modules
  for VAR in `printenv | grep DISABLEMODULE | cut -d= -f1 | cut -d_ -f2- | awk '{print tolower($0)}'`
  do
      if [[ -f "$PHPMODULES/*$VAR.ini" ]]
      then
          ${VERBOSE_MODE} && echo "Disabling Module $VAR ..."
          rm "$PHPMODULES/*$VAR.ini"
      elif [[ -f "$PHPMODULES/$VAR.ini" ]]
      then
          ${VERBOSE_MODE} && echo "Disabling Module $VAR ..."
          rm "$PHPMODULES/$VAR.ini"
      else
          ${VERBOSE_MODE} && echo "Module not found $VAR"
      fi
  done
  ${VERBOSE_MODE} && echo

  # List available modules
  if [[ "$VERBOSE" == "true" ]]
  then
      echo "Available Modules:"
      for VAR in `ls $PHPMODULES/ | sort`
      do
          echo $VAR | awk -F"." '{printf $1; printf " "}'
      done
      echo
  fi

  # No arguments, simply exit
  if [[ -z "$1" ]];
  then
      exit;
  fi

  # Copy Custom Config
  cp $PHPCUSTOM/*.ini $PHPMODULES/ 2>/dev/null || :
fi

exec "$@"
