#!/usr/bin/env bash

FPMBASE="/etc/$PHP_VARIANT/php-fpm.d/base.conf"
FPMWWW="/etc/$PHP_VARIANT/php-fpm.d/www.conf"
FPMENV="/etc/$PHP_VARIANT/php-fpm.d/env.conf"
FPMMAIN="/etc/$PHP_VARIANT/php-fpm.conf" 

VERBOSE_MODE=false
if [ "$VERBOSE" == "true" ]
then
    VERBOSE_MODE=true
fi

${VERBOSE_MODE} && echo "=== PHP-FPM ==========================================================="

if [ -z "$PHP_FPM_SERVER" ]
then
  PHP_FPM_SERVER=0.0.0.0:9000
fi
${VERBOSE_MODE} && echo "Setting FPM fastcgi to '$PHP_FPM_SERVER'"
sed -i "s|@fastcgi@|${PHP_FPM_SERVER}|g" $FPMBASE
sed -i "s|@fastcgi@|${PHP_FPM_SERVER}|g" $FPMWWW

# Function to update the fpm configuration to make the service environment variables available
function setEnvironmentVariable() {

    if [ -z "$2" ]; then
        ${VERBOSE_MODE} && echo "Environment variable '$1' is empty."
        return
    fi

    ${VERBOSE_MODE} && echo "$1 = '$2'"
    # Check whether variable already exists
    if grep -q $1 "$FPMENV"; then
        # Reset variable
        sed -i "s~^env\[$1\].*~env[$1] = $2~g" "$FPMENV"
    else
        # Add variable
        echo "env[$1] = $2" >> "$FPMENV"
    fi
}

# Grep for variables that look like docker set them (_PORT_)
if [ -z "$PHP_FPM_IGNORE_ENV"]
then
  ${VERBOSE_MODE} && echo "Environment Variables: "
  echo "clear_env = no" > $FPMENV
  for _curVar in `env | sort | awk -F = '{print $1}'`;do
     # awk has split them by the equals sign
     # Pass the name and value to our function
     setEnvironmentVariable ${_curVar} ${!_curVar}
  done
fi

# Log something to the supervisord log so we know this script as run
${VERBOSE_MODE} && echo "DONE"

# Now start php-fpm
$(command -v php-fpm) --nodaemonize --fpm-config "$FPMMAIN"