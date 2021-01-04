#!/usr/bin/env bash

FPMCONFIG="/etc/$PHP_VARIANT/php-fpm.d/www.conf"
if [ "$PHP_VARIANT" == "php5" ]
then
    FPMCONFIG="/etc/php5/php-fpm.conf"
fi

sed -i -e 's/^\(listen *=\).*/\1 0.0.0.0:9000/g' $FPMCONFIG

# Function to update the fpm configuration to make the service environment variables available
function setEnvironmentVariable() {

    if [ -z "$2" ]; then
        echo "Environment variable '$1' not set."
        return
    fi

    # Check whether variable already exists
    if grep -q $1 "$FPMCONFIG"; then
        # Reset variable
        sed -i "s~^env\[$1\].*~env[$1] = $2~g" "$FPMCONFIG"
    else
        # Add variable
        echo "env[$1] = $2" >> "$FPMCONFIG"
    fi
}

# Grep for variables that look like docker set them (_PORT_)
for _curVar in `env | awk -F = '{print $1}'`;do
    # awk has split them by the equals sign
    # Pass the name and value to our function
    setEnvironmentVariable ${_curVar} ${!_curVar}
done

# Log something to the supervisord log so we know this script as run
echo "DONE"

# Now start php-fpm
$(command -v php-fpm) --nodaemonize --fpm-config "$FPMCONFIG"