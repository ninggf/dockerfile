# wulaphp/php

为[wulaphp](https://www.wulaphp.com)框架定制的`PHP`镜像以方便大家进行快速开发。此镜像包括了wulaphp需要的所有扩展（包括推荐的扩展）。

## 启动容器

`$docker run -d -e XDEBUG_ENABLE=1 windywany/php:latest`

> 可选择适合你的版本对应的**tag**，`latest`对应`7.3.x`版本。

### 环境变量

* `XDEBUG_REMOTE_HOST`: IDE所在主机IP,默认为`host.docker.internal`。
* `XDEBUG_REMOTE_PORT`: IDE监听的端口,默认`9000`。
* `XDEBUG_ENABLE`: 等于1时开启`xdebug`调试,默认`0`。
* `APCU_ENABLE`: 等于1时启用`apcu`运行时缓存,默认`0`。

## VOLUME

* `/var/www/html`
* `/usr/local/etc/php/php.ini`: PHP 配置文件
* `/usr/local/etc/php-fpm.d/www.conf`: fpm www pool配置文件

## EXPOSE

`9000/tcp`

## User

`www-data`

### 联系

转到[wulaphp](https://www.wulaphp.com)以了解更多信息。
