FROM php:7.4.21-cli-alpine3.14

LABEL vendor="wulaphp Dev Team" \
    version="7.4.21-cli" \
    description="Official wulaphp docker image with specified extensions"

RUN apk update &&\
    apk add --no-cache --virtual .phpize-deps $PHPIZE_DEPS &&\
    apk add --no-cache libpng-dev zlib-dev libzip-dev libmemcached-dev freetype-dev;\
    pecl channel-update pecl.php.net &&\
    pecl install redis-5.3.1;\
    pecl install memcached-3.1.5;\
    docker-php-ext-enable redis memcached;\
    sed -i 's/apk add --no-cache/#apk add --no-cache/' /usr/local/bin/docker-php-ext-install &&\
    docker-php-ext-configure gd --with-freetype;\
    docker-php-ext-install -j$(nproc) gd pcntl \
    sockets bcmath pdo_mysql opcache zip;\
    cp /usr/local/etc/php/php.ini-development /usr/local/etc/php/php.ini;\
    apk del --no-network .phpize-deps;\
    pecl clear-cache;\
    rm -rf /tmp/pear/;\
    rm -rf /usr/src/php* /var/lib/apk/*

WORKDIR /var/www/html
