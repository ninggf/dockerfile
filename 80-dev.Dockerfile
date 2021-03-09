FROM php:8.0-fpm-alpine3.12

LABEL vendor="wulaphp Dev Team" \
    version="8.0.rc4-dev" \
    env.XDEBUG_CLIENT_HOST=host.docker.internal\
    env.XDEBUG_CLIENT_PORT=9000\
    env.XDEBUG_START_WITH_REQUEST=default\
    env.XDEBUG_TRIGGER_VALUE=\
    env.XDEBUG_IDEKEY=PHPSTORM\
    env.XDEBUG_MODE=off\
    description="Official wulaphp docker image with specified extensions"

ENV XDEBUG_CLIENT_PORT=9000 XDEBUG_START_WITH_REQUEST=default XDEBUG_IDEKEY=PHPSTORM\
    XDEBUG_CLIENT_HOST=host.docker.internal XDEBUG_MODE=off XDEBUG_TRIGGER_VALUE=

COPY docker-ng-entrypoint.sh /usr/local/bin/docker-ng-entrypoint

RUN apk update &&\
    apk add --no-cache --virtual .phpize-deps $PHPIZE_DEPS&&\
    apk add --no-cache libpng-dev zlib-dev libzip-dev libmemcached-dev freetype-dev;\
    sed -i 's/apk add --no-cache/#apk add --no-cache/' /usr/local/bin/docker-php-ext-install;\
    docker-php-ext-configure gd --with-freetype;\
    mkdir -p /usr/src/php/ext/redis /usr/src/php/ext/memcached /usr/src/php/ext/xdebug;\
    curl -fsSL https://pecl.php.net/get/redis | tar xvz -C "/usr/src/php/ext/redis" --strip 1;\
    curl -fsSL https://pecl.php.net/get/memcached | tar xvz -C "/usr/src/php/ext/memcached" --strip 1;\
    curl -fsSL https://pecl.php.net/get/xdebug | tar xvz -C "/usr/src/php/ext/xdebug" --strip 1;\
    docker-php-ext-install -j$(nproc) gd pcntl \
    sockets bcmath pdo_mysql opcache zip redis memcached xdebug;\
    mv /usr/local/etc/php/php.ini-development /usr/local/etc/php/php.ini;\
    apk del --no-network .phpize-deps;\
    apk add --no-cache nginx;\
    mv /etc/nginx /usr/local/etc/nginx;ln -s /usr/local/etc/nginx /etc/nginx;\
    rm -rf /usr/src/php* /var/lib/apk/* /usr/local/etc/php-fpm.d/*.conf;\
    chmod +x /usr/local/bin/docker-ng-entrypoint;

COPY etc80/ /usr/local/etc/

ENTRYPOINT ["docker-ng-entrypoint"]

CMD ["php-fpm"]