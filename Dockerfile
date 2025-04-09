# 基于官方7.4-fpm版本，增加常用扩展
FROM php:8.2-fpm-bullseye

# 安装必要的构建工具和依赖
RUN apt-get update && apt-get install -y \
    wget \
    git \
    build-essential \
    pkg-config \
    libtool \
    autoconf \
    automake \
    libjpeg-dev \
    libpng-dev \
    libfreetype6-dev \
    libwebp-dev \
    libzip-dev \
    libyaml-dev \
    libmagickwand-dev \
    && rm -rf /var/lib/apt/lists/*

# 设置架构特定的环境变量
ENV CFLAGS="-O2 -march=native"
ENV CXXFLAGS="-O2 -march=native"

# 安装PHP扩展
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN chmod +x /usr/local/bin/install-php-extensions && \
    install-php-extensions gd exif imagick zip calendar gettext yaml \
    mysqli pdo_mysql redis @composer

# 清理
RUN apt-get clean
