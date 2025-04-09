# 构建阶段
FROM --platform=$BUILDPLATFORM php:8.2-fpm-bullseye as builder

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
ENV CFLAGS="-O2 -march=armv7-a -mfpu=neon -mfloat-abi=hard"
ENV CXXFLAGS="-O2 -march=armv7-a -mfpu=neon -mfloat-abi=hard"

# 安装PHP扩展
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN chmod +x /usr/local/bin/install-php-extensions && \
    install-php-extensions gd exif imagick zip calendar gettext yaml \
    mysqli pdo_mysql redis @composer

# 最终阶段
FROM php:8.2-fpm-bullseye

# 复制构建阶段的扩展
COPY --from=builder /usr/local/lib/php/extensions/ /usr/local/lib/php/extensions/
COPY --from=builder /usr/local/etc/php/conf.d/ /usr/local/etc/php/conf.d/

# 安装运行时依赖
RUN apt-get update && apt-get install -y \
    libjpeg62-turbo \
    libpng16-16 \
    libfreetype6 \
    libwebp6 \
    libzip4 \
    libyaml-0-2 \
    libmagickwand-6.q16-6 \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean
