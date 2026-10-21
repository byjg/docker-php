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
# The module is found by the extension line of its ini file, whatever the file name:
# "70_yaml.ini" (apk), "80-yaml.ini" (PIE). A module already disabled is not an error, so it is
# safe to run again. Exits with 1 if any module was not found.
#
# The modules that require a disabled one are disabled too (e.g. dom also disables xmlreader
# and xsl). --all-except keeps the modules the given ones require (e.g. pdo_mysql keeps pdo and
# mysqlnd). Both exit with 1 if PHP does not start cleanly afterwards.
#

if [[ -z "$1" ]]; then
    sed -n '3,21p' "$0" | sed 's/^# \{0,1\}//'
    exit 1
fi

PHPMODULES=$(php -i | grep "Scan this dir" | awk -F" => " '{print $2}')
EXTENSION_DIR=$(php -r 'echo ini_get("extension_dir");')
LOADED=" $(php -m 2>/dev/null | awk '{print tolower($0)}' | tr '\n' ' ') "

# "<module> <ini file>" for each ini file in the scan directory that loads a module. The module
# comes from the extension line, not the file name: "30_sqlsvr.ini" loads pdo_sqlsrv.
module_inis() {
    local FILE
    for FILE in "$PHPMODULES"/*.ini
    do
        [[ -f "$FILE" ]] || continue
        grep -E '^\s*(zend_)?extension\s*=' "$FILE" \
            | sed -E 's/^[^=]*=\s*"?([^";[:space:]]*).*/\1/; s|.*/||; s/\.so$//' \
            | awk -v f="${FILE##*/}" '{print tolower($0), f}'
    done
}

# A module can be disabled when an ini file in the scan directory loads it
list_modules() {
    module_inis | awk '{print $1}' | sort -u
}

# The ini files of a module: the ones that load it, plus "<module>.ini" or "70_<module>.ini"
# that only have its settings
module_files() {
    local FILE
    {
        module_inis | awk -v m="$1" '$1 == m {print $2}'
        for FILE in "$PHPMODULES"/*.ini
        do
            [[ "${FILE##*/}" =~ ^([0-9]+[_-])?"$1"\.ini$ ]] && echo "${FILE##*/}"
        done
    } | sort -u
}

# enabled:  an ini file loads it
# builtin:  compiled into PHP (e.g. json, spl), it has no ini file and cannot be disabled
# disabled: its library is installed but no ini file loads it (e.g. a previous run disabled it)
# missing:  not in this image
module_state() {
    if module_inis | awk -v m="$1" '$1 == m {found = 1} END {exit !found}'; then
        echo enabled
    elif [[ "$LOADED" == *" $1 "* ]]; then
        echo builtin
    elif [[ -f "$EXTENSION_DIR/$1.so" ]]; then
        echo disabled
    else
        echo missing
    fi
}

# The apk packages that installed the ini files of a module (none for a module PIE built)
module_packages() {
    local FILE
    for FILE in $(module_files "$1")
    do
        apk info -W "$PHPMODULES/$FILE" 2>/dev/null | awk '/is owned by/ {print $NF}' | sed -E 's/-[0-9][^-]*-r[0-9]+$//'
    done | sort -u
}

# The enabled modules of the PHP packages apk relates to a module: "-R" the packages it depends on,
# "-r" the packages that depend on it
apk_modules() {
    local PACKAGES PACKAGE INI
    mapfile -t PACKAGES < <(module_packages "$2")
    [[ ${#PACKAGES[@]} -eq 0 ]] && return
    for PACKAGE in $(apk info "$1" "${PACKAGES[@]}" 2>/dev/null | grep -v ':$' | grep -E '^php[0-9]*-' | sed -E 's/[<>=~].*//; s/-[0-9][^-]*-r[0-9]+$//')
    do
        for INI in $(apk info -L "$PACKAGE" 2>/dev/null | grep -E "/conf\.d/[^/]+\.ini$" | sed -E 's|.*/||')
        do
            module_inis | awk -v f="$INI" '$2 == f {print $1}'
        done
    done
}

# "<module> <module it requires>" for every loaded module, as PHP declares it
# shellcheck disable=SC2016 # the $ belong to the PHP code
PHP_DEPENDENCIES=$(php -r '
    foreach (get_loaded_extensions() as $ext) {
        foreach ((new ReflectionExtension($ext))->getDependencies() as $dep => $type) {
            if ($type === "Required") {
                echo strtolower($ext), " ", strtolower($dep), "\n";
            }
        }
    }
' 2>/dev/null)

# --requires: the modules a module requires. The ones PHP declares, plus the apk package
# dependencies, which also list libraries PHP does not declare (e.g. mysqlnd needs openssl).
# --required-by: the enabled modules that require a module (e.g. xmlreader and xsl require dom).
# A module PIE built has no apk package, so only what PHP declares is known for it.
related() {
    case "$1" in
        --requires)
            echo "$PHP_DEPENDENCIES" | awk -v m="$2" '$1 == m {print $2}'
            apk_modules -R "$2"
            ;;
        --required-by)
            echo "$PHP_DEPENDENCIES" | awk -v m="$2" '$2 == m {print $1}'
            apk_modules -r "$2"
            ;;
    esac
}

# "<module> <the module that added it>" for the given modules and every one related to them
# (--requires or --required-by), until no new one shows up
closure() {
    local DIRECTION=$1 ALL MODULE DEP
    local -a QUEUE NEXT
    shift
    [[ $# -eq 0 ]] && return
    ALL=" $* "
    QUEUE=("$@")
    printf '%s\n' "$@"
    while [[ ${#QUEUE[@]} -gt 0 ]]
    do
        NEXT=()
        for MODULE in "${QUEUE[@]}"
        do
            for DEP in $(related "$DIRECTION" "$MODULE")
            do
                if [[ "$ALL" != *" $DEP "* ]]; then
                    ALL="$ALL$DEP "
                    NEXT+=("$DEP")
                    echo "$DEP $MODULE"
                fi
            done
        done
        QUEUE=("${NEXT[@]}")
    done
}

disable_module() {
    local FILE
    for FILE in $(module_files "$1")
    do
        rm -f "${PHPMODULES:?}/$FILE"
    done
}

# A module can need another one neither PHP nor apk declares; it then fails to load
check_php() {
    local ERRORS
    ERRORS=$(php -v 2>&1 | grep -E 'Warning|Fatal error')
    if [[ -n "$ERRORS" ]]; then
        echo "PHP does not start cleanly after disabling the modules:" >&2
        echo "$ERRORS" >&2
        exit 1
    fi
}

lowercase() {
    printf '%s\n' "$@" | awk 'NF {print tolower($0)}'
}

if [[ "$1" == "--list" ]]; then
    list_modules
    exit 0
fi

if [[ "$1" == "--all-except" ]]; then
    shift
    KEEP=()
    for MODULE in $(lowercase "$@")
    do
        case $(module_state "$MODULE") in
            missing)  echo "Module not found: $MODULE" >&2; exit 1 ;;
            disabled) echo "Module already disabled: $MODULE" ;;
        esac
        KEEP+=("$MODULE")
    done

    KEEP_ALL=" $(closure --requires "${KEEP[@]}" | awk '{print $1}' | tr '\n' ' ') "
    KEPT=""
    for MODULE in $(list_modules)
    do
        if [[ "$KEEP_ALL" == *" $MODULE "* ]]; then
            KEPT="$KEPT $MODULE"
        else
            echo "Disabling module $MODULE ..."
            disable_module "$MODULE"
        fi
    done
    echo "Keeping modules:$KEPT"
    check_php
    exit 0
fi

STATUS=0
DISABLE=()
for MODULE in $(lowercase "$@")
do
    case $(module_state "$MODULE") in
        enabled)  DISABLE+=("$MODULE") ;;
        disabled) echo "Module already disabled: $MODULE" ;;
        builtin)  echo "Module compiled into PHP, it cannot be disabled: $MODULE" >&2; STATUS=1 ;;
        missing)  echo "Module not found: $MODULE" >&2; STATUS=1 ;;
    esac
done

# The modules that require a disabled one can no longer load: disable them too
while read -r MODULE REQUIRED
do
    if [[ -n "$REQUIRED" ]]; then
        echo "Disabling module $MODULE (requires $REQUIRED) ..."
    else
        echo "Disabling module $MODULE ..."
    fi
    disable_module "$MODULE"
done < <(closure --required-by "${DISABLE[@]}")

check_php
exit $STATUS
