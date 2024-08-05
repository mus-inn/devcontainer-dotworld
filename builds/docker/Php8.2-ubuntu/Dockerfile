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
        php8.2-cli \
        php8.2-sqlite3 \
        php8.2-gd \
        php8.2-imagick \
        php8.2-curl \
        php8.2-imap \
        php8.2-mysql \
        php8.2-mbstring \
        php8.2-xml \
        php8.2-zip \
        php8.2-bcmath \
        php8.2-soap \
        php8.2-intl \
        php8.2-readline \
        php8.2-ldap \
        php8.2-msgpack \
        php8.2-igbinary \
        php8.2-redis \
        php8.2-swoole \
        php8.2-memcached \
        php8.2-pcov \
        mysql-client \
    && apt-get -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
   #install composer 
    && curl -sLS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer \
    && setcap "cap_net_bind_service=+ep" /usr/bin/php8.2

COPY start-container /usr/local/bin/start-container
COPY php.ini /etc/php/8.2/cli/conf.d/99-vscode.ini

RUN chmod +x /usr/local/bin/start-container

ENTRYPOINT ["start-container"]