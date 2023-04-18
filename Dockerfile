FROM php:8.1-fpm-buster
ENV WORKING_DIR="/var/www/public"

COPY php/php.ini /usr/local/etc/php/conf.d/docker-php-config.ini

RUN apt-get update && apt-get install -y \
    curl \
    gnupg \
    g++ \
    procps \
    openssl \
    git \
    unzip \
    zlib1g-dev \
    libcurl4-openssl-dev \
    libzip-dev \
    libfreetype6-dev \
    libpng-dev \
    libjpeg-dev \
    libicu-dev  \
    libonig-dev \
    libxslt1-dev \
    libssh-dev \
    librabbitmq-dev \
    acl \
    && pecl install amqp

RUN apt-get update && apt-get install -y \
    libc-client-dev \
    libkrb5-dev \
    && rm -r /var/lib/apt/lists/*

RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && docker-php-ext-install imap

RUN docker-php-ext-configure gd --with-jpeg --with-freetype \
    && docker-php-ext-install gd

RUN docker-php-ext-install \
    bcmath curl exif intl mbstring opcache pcntl pdo pdo_mysql sockets zip xsl

RUN docker-php-ext-enable \
    amqp

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

WORKDIR ${WORKING_DIR}