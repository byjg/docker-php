#!/usr/bin/env bash
#
# Disable PHP modules by removing their ini file from the PHP scan directory.
#
# Usage:
#   php-disable-module <module> [<module> ...]
#   php-disable-module --all-except <module> [<module> ...]
#   php-disable-module --list      list the modules that can be disabled
#
# Examples:
#   php-disable-module yaml
#   php-disable-module xdebug memcached
#   php-disable-module --all-except pdo_mysql mbstring
#
# The ini file can be "<module>.ini" or have a numeric priority prefix: "70_yaml.ini" (apk),
# "80-yaml.ini" (PIE). Exits with 1 if any module was not found.
#
# --all-except also keeps the modules the given ones require (e.g. pdo_mysql keeps pdo and
# mysqlnd), and exits with 1 if PHP does not start cleanly afterwards.
#

if [[ -z "$1" ]]; then
    sed -n '3,19p' "$0" | sed 's/^# \{0,1\}//'
    exit 1
fi

PHPMODULES=`php -i | grep "Scan this dir" | awk -F" => " '{print $2}'`

# A module can be disabled when an ini file in the scan directory loads it
list_modules() {
    (cd "$PHPMODULES" && grep -l -E '^\s*(zend_)?extension\s*=' *.ini 2>/dev/null) \
        | sed -E 's/^[0-9]+[_-]//; s/\.ini$//' | sort -u
}

# The modules a module requires: the ones PHP declares, plus the apk package dependencies, which
# also list libraries PHP does not declare (e.g. mysqlnd needs openssl). A module PIE built has no
# apk package, so only what PHP declares is known for it.
requires() {
    php -r '
        if (extension_loaded($argv[1])) {
            foreach ((new ReflectionExtension($argv[1]))->getDependencies() as $dep => $type) {
                if ($type === "Required") {
                    echo strtolower($dep), "\n";
                }
            }
        }
    ' -- "$1" 2>/dev/null

    local FILE PACKAGE DEP
    for FILE in `ls "$PHPMODULES" | grep -E "^([0-9]+[_-])?${1}\.ini$"`
    do
        PACKAGE=`apk info -W "$PHPMODULES/$FILE" 2>/dev/null | awk '/is owned by/ {print $NF}' | sed -E 's/-[0-9][^-]*-r[0-9]+$//'`
        [[ -z "$PACKAGE" ]] && continue
        for DEP in `apk info -R "$PACKAGE" 2>/dev/null | grep -v 'depends on' | grep -E '^php[0-9]*-'`
        do
            apk info -L "$DEP" 2>/dev/null | grep -E "/conf\.d/[^/]+\.ini$" \
                | sed -E 's|.*/||; s/^[0-9]+[_-]//; s/\.ini$//'
        done
    done
}

if [[ "$1" == "--list" ]]; then
    list_modules
    exit 0
fi

if [[ "$1" == "--all-except" ]]; then
    shift
    AVAILABLE=" `list_modules | tr '\n' ' '` "
    LOADED=" `php -m 2>/dev/null | awk '{print tolower($0)}' | tr '\n' ' '` "

    KEEP=""
    for MODULE in "$@"
    do
        MODULE=`echo "$MODULE" | awk '{print tolower($0)}'`
        # A module compiled into PHP (e.g. json, spl) has no ini file and is always enabled
        if [[ "$AVAILABLE" != *" $MODULE "* && "$LOADED" != *" $MODULE "* ]]; then
            echo "Module not found: $MODULE" >&2
            exit 1
        fi
        KEEP="$KEEP $MODULE"
    done

    # Add the modules they require, until no new one shows up
    QUEUE="$KEEP"
    while [[ -n "${QUEUE// /}" ]]
    do
        NEXT=""
        for MODULE in $QUEUE
        do
            for DEP in `requires "$MODULE"`
            do
                if [[ " $KEEP " != *" $DEP "* ]]; then
                    KEEP="$KEEP $DEP"
                    NEXT="$NEXT $DEP"
                fi
            done
        done
        QUEUE="$NEXT"
    done
    KEPT=""
    DISABLE=""
    for MODULE in $AVAILABLE
    do
        if [[ " $KEEP " == *" $MODULE "* ]]; then
            KEPT="$KEPT $MODULE"
        else
            DISABLE="$DISABLE $MODULE"
        fi
    done
    echo "Keeping modules:$KEPT"
    [[ -n "$DISABLE" ]] && "$0" $DISABLE

    # A module can need another one PHP does not declare; it then fails to load
    ERRORS=`php -v 2>&1 | grep -E 'Warning|Fatal error'`
    if [[ -n "$ERRORS" ]]; then
        echo "PHP does not start cleanly after disabling the modules:" >&2
        echo "$ERRORS" >&2
        exit 1
    fi
    exit 0
fi

STATUS=0
for MODULE in "$@"
do
    MODULE=`echo "$MODULE" | awk '{print tolower($0)}'`
    MODULE_FILES=`ls "$PHPMODULES" | grep -E "^([0-9]+[_-])?${MODULE}\.ini$"`
    if [[ -z "$MODULE_FILES" ]]
    then
        echo "Module not found: $MODULE" >&2
        STATUS=1
        continue
    fi

    echo "Disabling module $MODULE ..."
    for FILE in $MODULE_FILES
    do
        rm -f "$PHPMODULES/$FILE"
    done
done

exit $STATUS
