# Définir des arguments de build pour l'architecture et le système d'exploitation cibles
ARG TARGETOS
ARG TARGETARCH

# Utiliser l'image de base fournie
FROM --platform=$BUILDPLATFORM chdotworld/dotworld:node22-ubuntu


LABEL maintainer="Gtko"

ARG WWWGROUP=1000

WORKDIR /var/www/html

ENV DEBIAN_FRONTEND noninteractive

RUN curl -sS 'https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x14aa40ec0831756756d7f66c4f4ea0aae5267a6c' | gpg --dearmor | tee /etc/apt/keyrings/ppa_ondrej_php.gpg > /dev/null \
   && echo "deb [signed-by=/etc/apt/keyrings/ppa_ondrej_php.gpg] https://ppa.launchpadcontent.net/ondrej/php/ubuntu jammy main" > /etc/apt/sources.list.d/ppa_ondrej_php.list \
   && apt-get update \
    && apt-get install -y --no-install-recommends \
        sqlite3 \
        libcap2-bin \
        libpng-dev \
        python2 \
        librsvg2-bin \
        php8.1-cli \
        php8.1-sqlite3 \
        php8.1-gd \
        php8.1-imagick \
        php8.1-curl \
        php8.1-imap \
        php8.1-mysql \
        php8.1-mbstring \
        php8.1-xml \
        php8.1-zip \
        php8.1-bcmath \
        php8.1-soap \
        php8.1-intl \
        php8.1-readline \
        php8.1-ldap \
        php8.1-msgpack \
        php8.1-igbinary \
        php8.1-redis \
        php8.1-swoole \
        php8.1-memcached \
        php8.1-pcov \
        mysql-client \
    && apt-get -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
   #install composer 
    && curl -sLS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer \
    && setcap "cap_net_bind_service=+ep" /usr/bin/php8.1

COPY start-container /usr/local/bin/start-container
COPY php.ini /etc/php/8.1/cli/conf.d/99-vscode.ini

RUN chmod +x /usr/local/bin/start-container

ENTRYPOINT ["start-container"]