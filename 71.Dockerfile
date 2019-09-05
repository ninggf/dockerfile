FROM centos:7

RUN yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm;\
    yum -y install epel-release yum-utils;\
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
        php-xml php-sodium php-mysqlnd php-pecl-yaml php-pecl-yac php-bcmath php-pgsql;\
    yum clean all;\
    sed -i -e 's/run\/php-fpm/run/' \
           -e 's/;log_level = notice/log_level = warning/' /etc/php-fpm.conf;\
    sed -i -e 's/;date.timezone =/date.timezone = Asia\/Shanghai/' /etc/php.ini

VOLUME ["/var/www"]

WORKDIR /var/www

EXPOSE 9000

CMD ["/usr/sbin/php-fpm","-F"]
