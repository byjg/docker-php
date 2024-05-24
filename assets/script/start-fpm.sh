#!/usr/bin/env bash

FPMBASE="/etc/$PHP_VARIANT/php-fpm.d/base.conf"
FPMENV="/etc/$PHP_VARIANT/php-fpm.d/env.conf"
FPMMAIN="/etc/$PHP_VARIANT/php-fpm.conf" 

if [ -z "$PHP_FPM_SERVER"]; then
  sed -i  's/^\(listen *=\).*/\1 0.0.0.0:9000/g' $FPMBASE
fi

# Function to update the fpm configuration to make the service environment variables available
function setEnvironmentVariable() {

    if [ -z "$2" ]; then
        echo "Environment variable '$1' not set."
        return
    fi

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
  echo "clear_env = no" >> $FPMENV
  for _curVar in `env | awk -F = '{print $1}'`;do
     # awk has split them by the equals sign
     # Pass the name and value to our function
     setEnvironmentVariable ${_curVar} ${!_curVar}
  done
fi

# Log something to the supervisord log so we know this script as run
echo "DONE"

# Now start php-fpm
$(command -v php-fpm) --nodaemonize --fpm-config "$FPMMAIN"