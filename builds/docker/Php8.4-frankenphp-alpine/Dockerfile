ARG TARGETOS
ARG TARGETARCH

# Builder on Alpine to keep runtime small
FROM --platform=$BUILDPLATFORM dunglas/frankenphp:php8.4-alpine AS frankenphp

ENV DEBIAN_FRONTEND=noninteractive

RUN apk add --no-cache \
        git \
        unzip \
        icu-dev \
        libzip-dev \
        libpng-dev \
        libjpeg-turbo-dev \
        freetype-dev \
        oniguruma-dev \
        librsvg \
        sqlite \
        oniguruma \
        oniguruma-dev \
    && install-php-extensions \
        pdo_mysql \
        intl \
        zip \
        opcache \
        imap \
        ldap \
        pcov \
        redis \
        swoole \
        memcached \
        igbinary \
        msgpack \
        imagick \
        mbstring \
        sqlite3 \
        pcntl

RUN curl -sLS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer

WORKDIR /app/public
RUN mkdir -p /var/www && ln -s /app/public /var/www/html

# Final Alpine runtime with Node 22 (custom base)
FROM --platform=$BUILDPLATFORM chdotworld/dotworld:node22-alpine

LABEL maintainer="Thibaud WILLM <thibaud.willm@dotworld.ch>"

ARG WWWGROUP=1000

WORKDIR /app/public

ENV DEBIAN_FRONTEND=noninteractive

# Copy FrankenPHP runtime, PHP, composer and extensions from builder
COPY --from=frankenphp /usr/local/ /usr/local/
COPY --from=frankenphp /usr/bin/composer /usr/bin/composer

# Minimal runtime deps and permissions
RUN apk add --no-cache \
        libcap \
        librsvg \
        sqlite \
    && mkdir -p /config/caddy /data/caddy \
    && mkdir -p /var/www && ln -s /app/public /var/www/html || true \
    && setcap cap_net_bind_service=+ep /usr/local/bin/frankenphp || true

COPY start-container /usr/local/bin/start-container
COPY php.ini /usr/local/etc/php/conf.d/99-vscode.ini

RUN chmod +x /usr/local/bin/start-container

EXPOSE 80 443 443/udp

ENTRYPOINT ["start-container"]

