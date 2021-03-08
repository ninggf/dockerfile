FROM php:7.4.16-fpm-alpine3.12

LABEL vendor="wulaphp Dev Team" \
    version="7.4.16-ng-alphine" \
    description="Official wulaphp docker image with specified extensions"

COPY docker-ng-entrypoint.sh /usr/local/bin/docker-ng-entrypoint

RUN apk update &&\
    apk add --no-cache --virtual .phpize-deps $PHPIZE_DEPS&&\
    apk add --no-cache libpng-dev zlib-dev libzip-dev libmemcached-dev freetype-dev;\
    pecl channel-update pecl.php.net;\
    pecl install redis-5.3.1;\
    pecl install memcached-3.1.5;\
    pecl install yac-2.2.1;\
    docker-php-ext-enable redis memcached yac;\
    echo "yac.enable_cli = On" >> /usr/local/etc/php/conf.d/docker-php-ext-yac.ini;\
    sed -i 's/apk add --no-cache/#apk add --no-cache/' /usr/local/bin/docker-php-ext-install;\
    docker-php-ext-configure gd --with-freetype;\
    docker-php-ext-install -j$(nproc) gd pcntl \
    sockets bcmath pdo_mysql opcache zip;\
    cp /usr/local/etc/php/php.ini-development /usr/local/etc/php/php.ini;\
    apk del --no-network .phpize-deps;\
    apk add --no-cache nginx;\
    mv /etc/nginx /usr/local/etc/nginx;ln -s /usr/local/etc/nginx /etc/nginx;\
    pecl clear-cache;\
    rm -rf /tmp/pear/;\
    rm -rf /usr/src/php* /var/lib/apk/* /usr/local/etc/php-fpm.d/*.conf;\
    chmod +x /usr/local/bin/docker-ng-entrypoint;

COPY etc2/ /usr/local/etc/

ENTRYPOINT ["docker-ng-entrypoint"]

CMD ["php-fpm"]