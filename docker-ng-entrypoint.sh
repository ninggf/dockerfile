#!/bin/sh
set -e

if [ "${1#-}" != "$1" ]; then
    set -- php "$@"
else
    if [ -e /usr/local/var/run/nginx.pid ]; then
        rm -f /usr/local/var/run/nginx.pid
    fi
    nginx
fi

exec "$@"