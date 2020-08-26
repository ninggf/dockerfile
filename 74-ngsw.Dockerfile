FROM php:7.4.9-fpm

LABEL vendor="wulaphp Dev Team" \
    version="7.4.9-ngsw" \
    ent.XDEBUG_REMOTE_HOST=host.docker.internal\
    env.XDEBUG_REMOTE_PORT=9000\
    env.XDEBUG_ENABLE=0\
    env.XDEBUG_IDEKEY=PHPSTORM\
    env.APCU_ENABLE=0\
    env.NG_WORKER_PROCESSES=1\
    env.NG_WORKER_CONNECTIONS=1024\
    env.SKY_ENABLED=0\
    env.SKY_APPCODE=hello_sky\
    env.SKY_GRPC_SERVER=127.0.0.1:11800\
    description="Official wulaphp docker image with specified extensions"

ENV XDEBUG_REMOTE_PORT=9000 XDEBUG_ENABLE=0 XDEBUG_IDEKEY=PHPSTORM APCU_ENABLE=0 \
    XDEBUG_REMOTE_HOST=host.docker.internal NG_WORKER_CONNECTIONS=1024 NG_WORKER_PROCESSES=1 \
    SKY_ENABLED=0 SKY_APPCODE=hello_sky SKY_GRPC_SERVER=127.0.0.1:11800

COPY docker-ng-entrypoint.sh /usr/local/bin/
ADD ngsky.tar.bz2 /
# 安装scws,sockets,bcmath,pdo_mysql,pcntl,opcache,redis,xdebug,memcached,zip,igbinary
RUN apt-get update && apt-get install -y \
    libfreetype6-dev libzip-dev \
    libjpeg62-turbo-dev \
    libpng-dev libmemcached-dev zlib1g-dev libssl-dev libpcre++-dev libcurl4-openssl-dev libgrpc++-dev libprotobuf-dev curl;\
    docker-php-ext-install -j$(nproc) gd pcntl \
    sockets bcmath pdo_mysql opcache libxml zlib;\
    pecl channel-update pecl.php.net;\
    pecl install redis-5.3.1;\
    pecl install xdebug-2.9.6;\
    pecl install memcached-3.1.5;\
    pecl install igbinary-3.1.2;\
    pecl install apcu-5.1.18;\
    pecl install zip-1.19.0;\
    docker-php-ext-enable opcache redis xdebug memcached igbinary apcu zip;\
    echo install nginx; \
    cd /nginx-1.19.2/;\
    ./configure --user=www-data --group=www-data \
    --with-poll_module \
    --conf-path=/usr/local/etc/nginx/nginx.conf --with-file-aio \
    --with-http_v2_module \
    --with-http_realip_module \
    --without-http_scgi_module \
    --without-http_proxy_module \
    --without-http_geo_module --without-http_uwsgi_module \
    --http-log-path=/var/log/nginx/access.log \
    --error-log-path=/var/log/nginx/error.log \
    --pid-path=/usr/local/var/run/nginx.pid \
    --lock-path=/usr/local/var/run/nginx.lock \
    --http-client-body-temp-path=/usr/local/var/client_body_temp \
    --http-fastcgi-temp-path=/usr/local/var/fastcgi_temp;\
    make && make install; cd /;rm -rf /nginx-1.19.2/;\
    ln -s /usr/local/nginx/sbin/nginx /usr/local/bin/nginx;\
    cd /SkyAPM-php-sdk-3.3.2/;phpize && ./configure && make && make install;\
    cd /;rm -rf /SkyAPM-php-sdk-3.3.2/;\
    echo "alias ll='ls --color=auto -l'" >> /root/.bashrc;\
    apt-get remove -y libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev libmemcached-dev zlib1g-dev libssl-dev libzip-dev;\
    cp /usr/local/etc/php/php.ini-development /usr/local/etc/php/php.ini;\
    echo "apc.enabled = \${APCU_ENABLE}" >> /usr/local/etc/php/conf.d/docker-php-ext-apcu.ini;\
    apt-get clean;\
    pecl clear-cache;\
    rm -rf /tmp/pear/;\
    rm -rf /usr/src/php* /var/lib/apt/lists/* /var/log/apt/* /var/log/dpkg.log;\
    chmod +x /usr/local/bin/docker-ng-entrypoint.sh;

COPY etc1/ /usr/local/etc/

EXPOSE 80

ENTRYPOINT ["docker-ng-entrypoint.sh"]

CMD ["php-fpm"]