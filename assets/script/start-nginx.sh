#!/usr/bin/env bash

VERBOSE_MODE=false
if [ "$VERBOSE" == "true" ]
then
    VERBOSE_MODE=true
fi

${VERBOSE_MODE} && echo "=== NGINX ==========================================================="

if [ -z "$NGINX_ROOT" ]
then
  NGINX_ROOT=/var/www/html
fi
if [ -z "$PHP_FPM_SERVER" ]
then
  PHP_FPM_SERVER=127.0.0.1:9000
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

$(command -v nginx) -g "daemon off;"
