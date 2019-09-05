FROM php:7.1.32-fpm-stretch

ENV XDEBUG_REMOTE_PORT=9000 XDEBUG_ENABLE=0

ADD ./exts/scws-1.2.3.tar.bz2 /
ADD ./exts/gearman-2.0.5.tar.gz /
# 安装scws,sockets,bcmath,pdo_mysql,pcntl,opcache,redis,xdebug,memcached,zip,igbinary
RUN cd /scws-1.2.3/;./configure;make;make install;\
    cd /scws-1.2.3/phpext/;\
    phpize;./configure;make;make install;\
    docker-php-ext-install sockets bcmath pdo_mysql pcntl opcache libxml zlib;\
    apt-get update && apt-get install -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev libmemcached-dev zlib1g-dev libssl-dev libzip-dev libgearman-dev;\
    cd /pecl-gearman-gearman-2.0.5/;phpize && ./configure && make && make install;\
    docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/;\
    docker-php-ext-install -j$(nproc) gd;\
    pecl channel-update pecl.php.net;\
    pecl install redis-4.2.0;\
    pecl install xdebug-2.6.1;\
    pecl install memcached-3.0.4;\
    pecl install zip-1.15.4;\
    pecl install igbinary-2.0.8;\
    pecl install channel://pecl.php.net/yac-2.0.2;\
    docker-php-ext-enable redis xdebug memcached igbinary zip yac;\
    cd /;rm -rf /scws-1.2.3/ /pecl-gearman-gearman-2.0.5/;\
    echo "alias ll='ls --color=auto -l'" >> /root/.bashrc;\
    apt-get clean;

COPY etc/ /usr/local/etc/

VOLUME ["/data"]

WORKDIR /data/