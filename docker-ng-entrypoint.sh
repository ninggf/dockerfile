#!/bin/sh
set -e

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
    set -- php "$@"
fi

if [ ! -e "/usr/local/var/run/nginx.pid" ]; then
    /usr/local/nginx/sbin/nginx
fi

exec "$@"