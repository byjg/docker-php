#!/usr/bin/env bash

#
# https://learn.microsoft.com/en-us/sql/connect/odbc/linux-mac/installing-the-microsoft-odbc-driver-for-sql-server?view=sql-server-ver15&tabs=alpine18-install%2Calpine17-install%2Cdebian8-install%2Credhat7-13-install%2Crhel7-offline#alpine-linux
#

set -x


case $(uname -m) in
    x86_64)   ARCH="amd64" ;;
    aarch64|arm64)   ARCH="arm64" ;;
    *) ARCH="unsupported" ;;
esac
if [[ "unsupported" == "$ARCH" ]];
then
    echo "Alpine architecture $(uname -m) is not currently supported.";
    exit;
fi


cd /tmp

BASE_URL=https://download.microsoft.com/download/3/5/5/355d7943-a338-41a7-858d-53b259ea33f5
VERSION_ODBC=18_18.3.2.1-1_${ARCH}
VERSION_TOOLS=18_18.3.1.1-1_${ARCH}

wget ${BASE_URL}/msodbcsql${VERSION_ODBC}.apk
wget ${BASE_URL}/mssql-tools${VERSION_TOOLS}.apk
yes | apk add --allow-untrusted msodbcsql${VERSION_ODBC}.apk 
yes | apk add --allow-untrusted mssql-tools${VERSION_TOOLS}.apk
# The extension is enabled only when it builds, so a failed build leaves no .ini behind.
# pdo_sqlsrv does not build on every PHP version (e.g. 8.6, until Microsoft publishes a
# compatible release): the extension is then skipped, and the ODBC driver stays installed.
# Images with PIE (PHP 8.3+) use it; the older ones keep PECL.
if command -v pie-install >/dev/null;
then
    pie-install --deps unixodbc --build-deps unixodbc-dev microsoft/pdo_sqlsrv
    STATUS=$?
else
    apk add --no-cache --virtual .phpize-deps ${PHP_VARIANT}-dev build-base unixodbc-dev
    pecl install pdo_sqlsrv && echo extension=pdo_sqlsrv.so > /etc/${PHP_VARIANT}/conf.d/30_sqlsvr.ini
    STATUS=$?
    apk del .phpize-deps
fi
if [[ $STATUS -ne 0 ]];
then
    echo "SKIPPED: pdo_sqlsrv does not build on PHP ${PHP_VERSION} (see the build log above). The Microsoft ODBC driver is installed, the PHP extension is not." >&2
fi
rm -f msodbcsql${VERSION_ODBC}.apk
rm -f mssql-tools${VERSION_TOOLS}.apk
rm -rf pear
