FROM php:7.0-cli-alpine3.7

MAINTAINER wuyq <407069461@qq.com>

ENV TIMEZONE=Asia/Shanghai
RUN sed 's/http:\/\/dl-cdn.alpinelinux.org/https:\/\/mirrors.aliyun.com/g' -i /etc/apk/repositories


RUN apk add --no-cache git && \
    apk add --no-cache gettext libpng libmcrypt sqlite libxml2 libjpeg-turbo freetype libmemcached zlib && \
    apk add --no-cache --virtual .build-dependencies libxml2-dev sqlite-dev zlib-dev \
    libmcrypt-dev gettext-dev curl-dev freetype-dev libjpeg-turbo-dev libwebp-dev zlib-dev libxpm-dev libpng-dev libmemcached-dev && \
    docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-png-dir=/usr/include/ && \
    docker-php-ext-install gettext gd mysqli bcmath exif curl mcrypt mbstring opcache pdo pdo_mysql pdo_sqlite soap session xml xmlrpc zip && \
    curl -L -o /tmp/redis.tar.gz https://github.com/phpredis/phpredis/archive/4.3.0.tar.gz && \
    tar xfz /tmp/redis.tar.gz && \
    rm -r /tmp/redis.tar.gz && \
    mkdir -p /usr/src/php/ext && \
    mv phpredis-4.3.0 /usr/src/php/ext/redis && \
    docker-php-ext-install redis && \
    curl -L -o /tmp/memcached.tar.gz https://github.com/php-memcached-dev/php-memcached/archive/v3.1.3.tar.gz && \
    tar xfz /tmp/memcached.tar.gz && \
    rm -r /tmp/memcached.tar.gz && \
    mkdir -p /usr/src/php/ext && \
    mv php-memcached-3.1.3 /usr/src/php/ext/memcached && \
    docker-php-ext-install memcached && \
    apk del .build-dependencies && \
    docker-php-source delete

RUN wget https://mirrors.aliyun.com/composer/composer.phar -O /usr/local/bin/composer && \
    chmod a+x /usr/local/bin/composer && \
    mkdir -p /home/composer/.composer && \
    ln -s /root/.ssh /home/composer/.ssh 

ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_MEMORY_LIMIT=-1
ENV COMPOSER_HOME /home/composer/.composer

WORKDIR /usr/src/app

VOLUME ["/home/composer/.composer"]

ENTRYPOINT ["/usr/local/bin/php", "/usr/local/bin/composer"]
