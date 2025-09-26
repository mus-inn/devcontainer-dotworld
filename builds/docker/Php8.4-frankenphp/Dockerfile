ARG TARGETOS
ARG TARGETARCH

# Builder stage: prepare FrankenPHP, PHP runtime and extensions
FROM --platform=$BUILDPLATFORM dunglas/frankenphp:php8.4-bookworm AS frankenphp

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && install-php-extensions \
        pdo_mysql \
        gd \
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
    && rm -rf /var/lib/apt/lists/*

RUN curl -sLS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer

WORKDIR /app/public
RUN mkdir -p /var/www && ln -s /app/public /var/www/html

# Final stage: your Node 22 Ubuntu base image with FrankenPHP runtime
FROM --platform=$BUILDPLATFORM chdotworld/dotworld:node22-ubuntu

LABEL maintainer="Thibaud WILLM <thibaud.willm@dotworld.ch>"

ARG WWWGROUP=1000

WORKDIR /app/public

ENV DEBIAN_FRONTEND noninteractive

# Copy FrankenPHP runtime, PHP, composer and extensions from builder
COPY --from=frankenphp /usr/local/ /usr/local/
COPY --from=frankenphp /usr/bin/composer /usr/bin/composer

# Ensure expected folders and minimal tools, grant net bind capability
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        libcap2-bin \
        sqlite3 \
        librsvg2-bin \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /config/caddy /data/caddy \
    && mkdir -p /var/www && ln -s /app/public /var/www/html || true \
    && setcap "cap_net_bind_service=+ep" /usr/local/bin/frankenphp || true

COPY start-container /usr/local/bin/start-container
COPY php.ini /usr/local/etc/php/conf.d/99-vscode.ini

RUN chmod +x /usr/local/bin/start-container

COPY vscode-nopasswd /etc/sudoers.d/vscode

RUN chmod 440 /etc/sudoers.d/vscode

EXPOSE 80 443 443/udp

ENTRYPOINT ["start-container"]

