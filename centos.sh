#! /bin/bash

yum -y --nogpgcheck install http://rpms.remirepo.net/enterprise/remi-release-7.rpm
yum -y --nogpgcheck install epel-release yum-utils
yum-config-manager --disable remi-php54 > /dev/null
yum-config-manager --disable remi-php55 > /dev/null
yum-config-manager --disable remi-php56 > /dev/null
yum-config-manager --disable remi-php70 > /dev/null
yum-config-manager --enable remi-php71  > /dev/null
yum-config-manager --disable remi-php72 > /dev/null
yum-config-manager --disable remi-php73 > /dev/null
yum-config-manager --disable remi-php74 > /dev/null

yum install -y --nogpgcheck php-fpm php-cli php-gd php-mbstring php-pdo php-opcache php-redis \
               php-memcached php-pecl-gearman php-zip php-process php-pecl-xdebug \
               php-xml php-sodium php-mysqlnd php-pecl-yaml php-pecl-yac php-bcmath php-pgsql \
               mysql-server gearmand nginx memcached redis

yum clean all

sed -i -e 's/run\/php-fpm/run/' \
       -e 's/;log_level = notice/log_level = warning/' /etc/php-fpm.conf

sed -i -e 's/;date.timezone =/date.timezone = Asia\/Shanghai/' /etc/php.ini

mv /etc/php.d/20-shmop.ini /etc/php.d/20-shmop.ini.bak
mv /etc/php.d/20-sysvmsg.ini /etc/php.d/20-sysvmsg.ini.bak
mv /etc/php.d/20-sysvsem.ini /etc/php.d/20-sysvsem.ini.bak
mv /etc/php.d/20-sysvshm.ini /etc/php.d/20-sysvshm.ini.bak
mv /etc/php.d/30-wddx.ini /etc/php.d/30-wddx.ini.bak

echo -e "[xdebug]\n\
zend_extension=xdebug.so\n\
xdebug.remote_enable=0\n\
xdebug.remote_connect_back=1\n\
;xdebug.remote_host=127.0.0.1\n\
xdebug.remote_port=9000\n\
xdebug.remote_autostart=0\n\
xdebug.idekey=PHPSTORM\n\
xdebug.profiler_enable_trigger=1\n\
xdebug.profiler_enable_trigger_value=profile\n\
xdebug.profiler_output_dir=/tmp/xdebug_profile\n"\
> /etc/php.d/15-xdebug.ini

echo -e "[scws]\n\
extension=scws.so\n\
scws.default.charset=utf8\n\
scws.default.fpath=/usr/local/etc\n"\
> /etc/php.d/50-scws.ini

sed -i -e 's/;yac.enable=1/yac.enable=0/' /etc/php.d/40-yac.ini