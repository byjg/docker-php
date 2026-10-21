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

# Adjust PHP
if [[ -f /usr/bin/php ]]
then
  # Getting PHP INI Paths
  PHPINI=`php -i | grep "Loaded Configuration File" | awk -F" => " '{print $2}'`
  PHPMODULES=`php -i | grep "Scan this dir" |  awk -F" => " '{print $2}'`
  PHPCUSTOM=/etc/php/conf.d

  # Keep only these modules (and the ones they require): PHP_ENABLED_MODULES="pdo_mysql,mbstring"
  ENABLED_MODULES=`echo "$PHP_ENABLED_MODULES" | tr ',' ' '`
  if [[ -n "${ENABLED_MODULES// /}" ]]
  then
      if ${VERBOSE_MODE}
      then
          /usr/local/bin/php-disable-module --all-except $ENABLED_MODULES
      else
          /usr/local/bin/php-disable-module --all-except $ENABLED_MODULES > /dev/null
      fi
  fi

  # Disable modules: PHP_DISABLE_MODULES="yaml,memcached" (comma or space separated)
  DISABLE_MODULES=`echo "$PHP_DISABLE_MODULES" | tr ',' ' '`

  # Deprecated: DISABLEMODULE_<module>=true, will be removed in a future release
  DEPRECATED_MODULES=`printenv | grep -E '^DISABLEMODULE_[^=]+=(true|yes|1)$' | cut -d= -f1 | cut -d_ -f2-`
  if [[ -n "$DEPRECATED_MODULES" ]]
  then
      echo "DISABLEMODULE_<module> is deprecated, use PHP_DISABLE_MODULES=\"`echo $DEPRECATED_MODULES | tr '[:upper:] ' '[:lower:],'`\"" >&2
      DISABLE_MODULES="$DISABLE_MODULES $DEPRECATED_MODULES"
  fi

  if [[ -n "${DISABLE_MODULES// /}" ]]
  then
      if ${VERBOSE_MODE}
      then
          /usr/local/bin/php-disable-module $DISABLE_MODULES
          echo
      else
          /usr/local/bin/php-disable-module $DISABLE_MODULES > /dev/null
      fi
  fi

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
