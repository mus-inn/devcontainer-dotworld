ARG TARGETOS
ARG TARGETARCH

# Builder stage: FrankenPHP with PHP 8.4 and extensions
FROM --platform=$BUILDPLATFORM dunglas/frankenphp:php8.4-bookworm AS frankenphp

ENV DEBIAN_FRONTEND=noninteractive

# Install PHP extensions required for Laravel Octane
RUN install-php-extensions \
    pdo_mysql \
    pdo_sqlite \
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
    curl \
    xml \
    bcmath \
    soap \
    readline

# Install Composer
RUN curl -sLS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer

# Final stage: Node 22 Ubuntu base image with FrankenPHP runtime
FROM --platform=$BUILDPLATFORM chdotworld/dotworld:node22-ubuntu

LABEL maintainer="Thibaud WILLM <thibaud.willm@dotworld.ch>"

ARG WWWGROUP=1000

WORKDIR /var/www/html

ENV DEBIAN_FRONTEND noninteractive

# Install runtime dependencies for PHP extensions
# These libraries are needed for the extensions copied from the Debian-based FrankenPHP image
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        sqlite3 \
        libcap2-bin \
        librsvg2-bin \
        mysql-client \
        ca-certificates \
        libonig5 \
        libzip4 \
        libpng16-16 \
        libjpeg-turbo8 \
        libwebp7 \
        libfreetype6 \
        libgomp1 \
        libmagickwand-6.q16-6 \
        libmagickcore-6.q16-6 \
        libc-client2007e \
        libicu70 \
        libsodium23 \
        libpq5 \
        libmemcached11 \
        libssl3 \
        libxml2 \
        libxslt1.1 \
    && apt-get -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Copy FrankenPHP runtime, PHP, Composer and all extensions from builder
COPY --from=frankenphp /usr/local/bin/frankenphp /usr/local/bin/frankenphp
COPY --from=frankenphp /usr/local/ /usr/local/
COPY --from=frankenphp /usr/bin/composer /usr/bin/composer

# Copy critical Debian libraries from FrankenPHP image for PHP extensions compatibility
# These specific library versions are required by gd, intl, swoole, and other extensions
# Note: Using wildcards to support both x86_64 and aarch64 architectures
COPY --from=frankenphp /usr/lib/*/libgomp.so.1 /usr/local/lib/
COPY --from=frankenphp /usr/lib/*/libc-client.so.2007e /usr/local/lib/
COPY --from=frankenphp /usr/lib/*/libicuio.so.72 /usr/local/lib/
COPY --from=frankenphp /usr/lib/*/libicui18n.so.72 /usr/local/lib/
COPY --from=frankenphp /usr/lib/*/libicuuc.so.72 /usr/local/lib/
COPY --from=frankenphp /usr/lib/*/libicudata.so.72 /usr/local/lib/
COPY --from=frankenphp /usr/lib/*/libsodium.so.23 /usr/local/lib/
COPY --from=frankenphp /usr/lib/*/libpq.so.5 /usr/local/lib/
COPY --from=frankenphp /usr/lib/*/libmemcached.so.11 /usr/local/lib/
COPY --from=frankenphp /usr/lib/*/libzip.so.4 /usr/local/lib/

# Set proper permissions for FrankenPHP to bind to privileged ports and update library cache
RUN setcap "cap_net_bind_service=+ep" /usr/local/bin/frankenphp \
    && ldconfig

# Create necessary directories
RUN mkdir -p /config/caddy /data/caddy /.composer \
    && chmod -R ugo+rw /.composer

COPY start-container /usr/local/bin/start-container
COPY php.ini /usr/local/etc/php/conf.d/99-vscode.ini

RUN chmod +x /usr/local/bin/start-container

COPY vscode-nopasswd /etc/sudoers.d/vscode

RUN chmod 440 /etc/sudoers.d/vscode

EXPOSE 80 443 443/udp

ENTRYPOINT ["start-container"]

