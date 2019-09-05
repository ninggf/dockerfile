FROM centos:7

RUN yum -y --nogpgcheck install http://rpms.remirepo.net/enterprise/remi-release-7.rpm;\
    yum -y --nogpgcheck install epel-release yum-utils wget libtool gcc aclocal automake autoconf autoheader;\
    yum-config-manager --disable remi-php54 > /dev/null;\
    yum-config-manager --disable remi-php55 > /dev/null;\
    yum-config-manager --disable remi-php56 > /dev/null;\
    yum-config-manager --disable remi-php70 > /dev/null;\
    yum-config-manager --enable remi-php71  > /dev/null;\
    yum-config-manager --disable remi-php72 > /dev/null;\
    yum-config-manager --disable remi-php73 > /dev/null;\
    yum-config-manager --disable remi-php74 > /dev/null;\
    yum install -y php-fpm php-cli php-gd php-mbstring php-pdo php-opcache php-redis \
    php-memcached php-pecl-gearman php-zip php-process php-pecl-xdebug \
    php-xml php-sodium php-mysqlnd php-pecl-yaml php-pecl-yac php-bcmath php-pgsql php-devel;\
    sed -i -e 's/run\/php-fpm/run/' \
    -e 's/;log_level = notice/log_level = warning/' /etc/php-fpm.conf;\
    sed -i -e 's/;date.timezone =/date.timezone = Asia\/Shanghai/' /etc/php.ini;\
    sed -i -e 's/;yac.enable=1/yac.enable=0/' /etc/php.d/40-yac.ini;\
    mv /etc/php.d/20-shmop.ini /etc/php.d/20-shmop.ini.bak;\
    mv /etc/php.d/20-sysvmsg.ini /etc/php.d/20-sysvmsg.ini.bak;\
    mv /etc/php.d/20-sysvsem.ini /etc/php.d/20-sysvsem.ini.bak;\
    mv /etc/php.d/20-sysvshm.ini /etc/php.d/20-sysvshm.ini.bak;\
    mv /etc/php.d/30-wddx.ini /etc/php.d/30-wddx.ini.bak;\
    echo -e "[xdebug]\n\
    zend_extension=xdebug.so\n\
    xdebug.remote_enable=1\n\
    xdebug.remote_connect_back=1\n\
    xdebug.remote_port=9000\n\
    xdebug.remote_autostart=0\n\
    xdebug.idekey=PHPSTORM\n\
    xdebug.profiler_enable_trigger=1\n\
    xdebug.profiler_enable_trigger_value=profile\n\
    xdebug.profiler_output_dir=/tmp/xdebug_profile\n"\
    > /etc/php.d/15-xdebug.ini;\
    echo -e "[scws]\n\
    extension=scws.so\n\
    scws.default.charset=utf8\n\
    scws.default.fpath=/usr/local/etc\n"\
    > /etc/php.d/50-scws.ini;
RUN cd /tmp && wget https://github.com/hightman/scws/archive/1.2.3.tar.gz;\
    tar zxf 1.2.3.tar.gz;\
    cd cd scws-1.2.3 && ./acprep && ./configure && make && make install;\
    cd phpext && phpize && ./configure && make && make install;\
    yum erase -y  *-devel aclocal automake autoconf autoheader;\
    yum clean all;\
    rm -rf /tmp/scws-1.2.3 /tmp/1.2.3.tar.gz;

VOLUME ["/var/www"]

WORKDIR /var/www

EXPOSE 9000

CMD ["/usr/sbin/php-fpm","-F"]
