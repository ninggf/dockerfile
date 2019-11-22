FROM php:7.3.12-fpm-stretch

LABEL vendor="wulaphp Dev Team" \
    version="1.0" \
    ent.XDEBUG_REMOTE_HOST=host.docker.internal\
    env.XDEBUG_REMOTE_PORT=9000\
    env.XDEBUG_ENABLE=0\
    env.XDEBUG_IDEKEY=PHPSTORM\
    env.APCU_ENABLE=0\
    description="Official wulaphp docker image with specified extensions"

ENV XDEBUG_REMOTE_PORT=9000 XDEBUG_ENABLE=0 XDEBUG_IDEKEY=PHPSTORM APCU_ENABLE=0 \
    XDEBUG_REMOTE_HOST=host.docker.internal

ADD ./exts.tar.bz2 /

# 安装scws,sockets,bcmath,pdo_mysql,pcntl,opcache,redis,xdebug,memcached,zip,igbinary
RUN cd /scws-1.2.3/;./configure;make;make install;\
    cd /scws-1.2.3/phpext/;\
    phpize;./configure;make;make install;\
    apt-get update && apt-get install -y \
    libfreetype6-dev libzip-dev \
    libjpeg62-turbo-dev \
    libpng-dev libmemcached-dev zlib1g-dev libssl-dev libgearman-dev;\
    cd /pecl-gearman-gearman-2.0.5/;phpize && ./configure && make && make install;\
    docker-php-ext-install -j$(nproc) gd pcntl \
    sockets bcmath pdo_mysql opcache libxml zlib;\
    pecl channel-update pecl.php.net;\
    pecl install redis-5.0.2;\
    pecl install xdebug-2.7.2;\
    pecl install memcached-3.1.3;\
    pecl install igbinary-3.0.1;\
    pecl install apcu-5.1.17;\
    pecl install zip-1.15.4;\
    docker-php-ext-enable redis xdebug memcached igbinary apcu zip;\
    cd /;rm -rf /scws-1.2.3/ /pecl-gearman-gearman-2.0.5/;\
    echo "alias ll='ls --color=auto -l'" >> /root/.bashrc;\
    apt-get remove -y libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev libmemcached-dev zlib1g-dev libssl-dev libzip-dev libgearman-dev;\
    cp /usr/local/etc/php/php.ini-development /usr/local/etc/php/php.ini;\
    echo "apc.enabled = \${APCU_ENABLE}" >> /usr/local/etc/php/conf.d/docker-php-ext-apcu.ini;\
    apt-get clean;\
    rm -rf /tmp/pear/;\
    rm -rf /usr/src/php/;

COPY etc/ /usr/local/etc/

VOLUME [ "/var/www/html" ]

WORKDIR /var/www/html
