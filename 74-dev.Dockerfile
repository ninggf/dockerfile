FROM php:7.4.21-fpm-alpine3.14

LABEL vendor="wulaphp Dev Team" \
    version="7.4.21-dev" \
    env.XDEBUG_REMOTE_HOST=host.docker.internal\
    env.XDEBUG_REMOTE_PORT=9000\
    env.XDEBUG_ENABLE=1\
    env.XDEBUG_IDEKEY=PHPSTORM\
    description="Official wulaphp docker image with specified extensions"

ENV XDEBUG_REMOTE_PORT=9000 XDEBUG_ENABLE=1 XDEBUG_IDEKEY=PHPSTORM \
    XDEBUG_REMOTE_HOST=host.docker.internal

COPY docker-ng-entrypoint.sh /usr/local/bin/docker-ng-entrypoint

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories &&\
    apk update &&\
    apk add --no-cache --virtual .phpize-deps $PHPIZE_DEPS &&\
    apk add --no-cache libpng-dev zlib-dev libzip-dev libmemcached-dev freetype-dev &&\
    pecl channel-update pecl.php.net &&\
    pecl install redis-5.3.4 &&\
    pecl install memcached-3.1.5 && \
    pecl install xdebug-2.9.8 && \
    docker-php-ext-enable redis memcached xdebug &&\
    sed -i 's/apk add --no-cache/#apk add --no-cache/' /usr/local/bin/docker-php-ext-install &&\
    docker-php-ext-configure gd --with-freetype &&\
    docker-php-ext-install -j$(nproc) gd pcntl \
    sockets bcmath pdo_mysql opcache zip &&\
    cp /usr/local/etc/php/php.ini-development /usr/local/etc/php/php.ini &&\
    apk del --no-network .phpize-deps &&\
    apk add --no-cache nginx &&\
    mv /etc/nginx /usr/local/etc/nginx;ln -s /usr/local/etc/nginx /etc/nginx &&\
    pecl clear-cache &&\
    rm -rf /tmp/pear/ &&\
    rm -rf /usr/src/php* /var/lib/apk/* /usr/local/etc/php-fpm.d/*.conf &&\
    chmod +x /usr/local/bin/docker-ng-entrypoint

COPY etc3/ /usr/local/etc/

ENTRYPOINT ["docker-ng-entrypoint"]

CMD ["php-fpm"]