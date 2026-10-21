#!/usr/bin/env bash
#
# Install a PHP extension with PIE (https://github.com/php/pie) and leave no build tools behind.
#
# Usage (as root):
#   pie-install [--build-deps "<apk packages>"] [--deps "<apk packages>"] <vendor/package>[:<constraint>] [pie options]
#
#   --build-deps  extra apk packages needed only to compile the extension (removed at the end)
#   --deps        apk packages the extension needs at runtime (kept in the image)
#
# Examples:
#   pie-install apcu/apcu
#   pie-install --build-deps "imagemagick-dev" --deps "imagemagick" imagick/imagick
#   pie-install xdebug/xdebug:^3.4 --skip-enable-extension
#
# PIE enables the extension by writing /etc/${PHP_VARIANT}/conf.d/<priority>-<extension>.ini
#

set -e

if [[ "$(id -u)" != "0" ]]; then
    echo "pie-install must run as root (add 'USER root' before it in your Dockerfile)." >&2
    exit 1
fi

BUILD_DEPS=""
DEPS=""
while [[ $# -gt 0 ]]; do
    case "$1" in
        --build-deps) BUILD_DEPS="$2"; shift 2 ;;
        --deps)       DEPS="$2"; shift 2 ;;
        *) break ;;
    esac
done

if [[ -z "$1" ]]; then
    sed -n '3,14p' "$0" | sed 's/^# \{0,1\}//'
    exit 1
fi

# The edge/testing repository is where Alpine publishes the newest PHP (e.g. php86-dev)
REPOSITORY="--repository https://dl-cdn.alpinelinux.org/alpine/edge/testing"

if [[ -n "$DEPS" ]]; then
    apk add --no-cache $REPOSITORY $DEPS
fi
apk add --no-cache $REPOSITORY --virtual .pie-build-deps \
    ${PHP_VARIANT}-dev autoconf build-base libtool linux-headers pkgconf $BUILD_DEPS

STATUS=0
pie install -n "$@" || STATUS=$?

# PIE saves long build output to /tmp/pie_*; show it before it is cleaned up
if [[ $STATUS -ne 0 ]]; then
    tail -n 40 /tmp/pie_* 2>/dev/null || true
fi

apk del --no-cache .pie-build-deps
rm -rf /root/.pie /root/.composer/cache /tmp/pie_*

exit $STATUS
