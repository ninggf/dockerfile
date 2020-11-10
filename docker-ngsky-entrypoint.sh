#!/bin/sh
set -e

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
    set -- php "$@"
fi

if [ ! -e "/usr/local/var/run/nginx.pid" ]; then
    /usr/local/nginx/sbin/nginx
    sky-php-agent --grpc ${SKY_GRPC_SERVER} --socket /tmp/sky-agent.sock > /var/log/sky-php.log 2>&1 &
fi

exec "$@"