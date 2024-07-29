# Utiliser l'image de base fournie
FROM chdotworld/dotworld:base-alpine

# Label de mainteneur
LABEL mainteneur="Gtko"

# Arguments de build
ARG NODE_VERSION=18

# Définir le répertoire de travail
WORKDIR /var/www/html

# Variables d'environnement
ENV TZ=Europe/Paris
ENV NVM_DIR=/usr/local/nvm
ENV NODE_VERSION=$NODE_VERSION

# Passer à l'utilisateur root pour les installations
USER root

# Ajouter les dépôts nécessaires
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories && \
    echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
    echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories

# Mise à jour initiale et installation des outils nécessaires
RUN apk update && apk add --no-cache \
    icu-libs \
    libavif \
    gnu-libiconv \
    gcc \
    g++ \
    make \
    cmake \
    pkgconf \
    sqlite-dev \
    libxml2-dev \
    curl-dev \
    openssl-dev \
    zlib-dev \
    wget \
    tzdata \
    mysql-client \
    docker-cli \
    coreutils \
    oniguruma-dev \
    tini

# Installation de PHP 8.1 et extensions depuis les dépôts edge
RUN apk add --no-cache \
    php81 \
    php81-dev \
    php81-common \
    php81-gd \
    php81-xmlreader \
    php81-bcmath \
    php81-ctype \
    php81-curl \
    php81-exif \
    php81-iconv \
    php81-intl \
    php81-mbstring \
    php81-opcache \
    php81-openssl \
    php81-pcntl \
    php81-phar \
    php81-session \
    php81-xml \
    php81-xsl \
    php81-zip \
    php81-zlib \
    php81-dom \
    php81-fpm \
    php81-sodium \
    php81-tokenizer \
    php81-pecl-apcu && \
    ln -sf /usr/bin/php81 /usr/bin/php

# Configuration du fuseau horaire
RUN cp /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Installation de nvm et Node.js
RUN mkdir -p $NVM_DIR && \
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash && \
    . $NVM_DIR/nvm.sh && \
    nvm install $NODE_VERSION && \
    nvm use $NODE_VERSION && \
    nvm alias default $NODE_VERSION && \
    ln -s $NVM_DIR/versions/node/v$NODE_VERSION/bin/node /usr/local/bin/node && \
    ln -s $NVM_DIR/versions/node/v$NODE_VERSION/bin/npm /usr/local/bin/npm

# Nettoyer les caches de paquets pour économiser de l'espace
RUN rm -rf /var/cache/apk/*

# Installation de Composer
RUN curl -sLS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer

# Copie de fichiers de configuration
COPY start-container /usr/local/bin/start-container
COPY php.ini /etc/php81/conf.d/99-vscode.ini
COPY xdebug.ini /etc/php81/conf.d/20-xdebug.ini

# Configuration des permissions
RUN chmod +x /usr/local/bin/start-container

# Point d'entrée du conteneur
ENTRYPOINT ["start-container"]
