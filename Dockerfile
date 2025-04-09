# 基于官方8.2-fpm版本，增加常用扩展
FROM php:8.2-fpm-bullseye

# 更改源 使用github action构建不需要更改源
# RUN sed -i "s/deb.debian.org/mirrors.aliyun.com/g" /etc/apt/sources.list

RUN apt-get update

#安装
RUN apt-get install -y wget

# 安装PHP扩展
# ADD https://mirror.ghproxy.com/https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN chmod +x /usr/local/bin/install-php-extensions

RUN install-php-extensions gd exif zip calendar gettext yaml iconv ctype gettext json mbstring curl dom xml session
RUN install-php-extensions mysqli pdo pdo_mysql redis @composer
RUN install-php-extensions imagick

# 清理
RUN rm -rf /var/lib/apt/lists/* && \
    apt-get clean
