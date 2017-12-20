#!/bin/sh
set -e

rm -f /etc/htpasswd.d/htpasswd
for i in `seq 1 ${HTCOUNT}`;
do
    CREATE=""
    if [ "$i" == "1" ]; then
        CREATE="-c"
    fi
    USERTMP=USR${i}
    eval USERX=\$$USERTMP
    PWDXTMP=PWD${i}
    eval PWDX=\$$PWDXTMP
    htpasswd -b ${CREATE} /etc/htpasswd.d/htpasswd ${USERX} ${PWDX}
done

exec "$@"