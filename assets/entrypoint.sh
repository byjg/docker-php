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
    echo "Build Date: $(cat /etc/build-date)"
    echo
fi

# Adjust PHP
if [[ -f /usr/bin/php ]]
then
  # Getting PHP INI Paths
  PHPMODULES=$(php -i | grep "Scan this dir" |  awk -F" => " '{print $2}')
  PHPCUSTOM=/etc/php/conf.d

  # Errors are always shown and stop the container; VERBOSE only shows the modules disabled.
  # A module already disabled (e.g. after a restart) is not an error.
  MODULE_OUTPUT=/dev/null
  ${VERBOSE_MODE} && MODULE_OUTPUT=/dev/stdout

  # Keep only these modules (and the ones they require): PHP_ENABLED_MODULES="pdo_mysql,mbstring"
  read -r -a ENABLED_MODULES <<< "${PHP_ENABLED_MODULES//,/ }"
  if [[ ${#ENABLED_MODULES[@]} -gt 0 ]]
  then
      if ! /usr/local/bin/php-disable-module --all-except "${ENABLED_MODULES[@]}" > "$MODULE_OUTPUT"
      then
          echo "PHP_ENABLED_MODULES=\"$PHP_ENABLED_MODULES\" failed (see above), stopping the container." >&2
          exit 1
      fi
  fi

  # Disable modules (and the ones that require them): PHP_DISABLE_MODULES="yaml,memcached"
  read -r -a DISABLE_MODULES <<< "${PHP_DISABLE_MODULES//,/ }"
  if [[ ${#DISABLE_MODULES[@]} -gt 0 ]]
  then
      if ! /usr/local/bin/php-disable-module "${DISABLE_MODULES[@]}" > "$MODULE_OUTPUT"
      then
          echo "PHP_DISABLE_MODULES=\"$PHP_DISABLE_MODULES\" failed (see above), stopping the container." >&2
          exit 1
      fi
  fi

  # Deprecated: DISABLEMODULE_<module>=true, will be removed in a future release. It does not stop
  # the container on an error, as it did not before.
  mapfile -t DEPRECATED_MODULES < <(printenv | grep -E '^DISABLEMODULE_[^=]+=(true|yes|1)$' | cut -d= -f1 | cut -d_ -f2- | awk '{print tolower($0)}')
  if [[ ${#DEPRECATED_MODULES[@]} -gt 0 ]]
  then
      echo "DISABLEMODULE_<module> is deprecated, use PHP_DISABLE_MODULES=\"$(IFS=,; echo "${DEPRECATED_MODULES[*]}")\"" >&2
      /usr/local/bin/php-disable-module "${DEPRECATED_MODULES[@]}" > "$MODULE_OUTPUT"
  fi

  # List the enabled modules
  if ${VERBOSE_MODE}
  then
      echo
      echo "Available Modules:"
      /usr/local/bin/php-disable-module --list | tr '\n' ' '
      echo
  fi

  # No arguments, simply exit
  if [[ -z "$1" ]];
  then
      exit;
  fi

  # Copy Custom Config
  cp "$PHPCUSTOM"/*.ini "$PHPMODULES"/ 2>/dev/null || :
fi

exec "$@"
