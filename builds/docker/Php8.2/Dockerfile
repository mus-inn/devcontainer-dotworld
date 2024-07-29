# Utiliser l'image de base fournie
FROM chdotworld/dotworld:base-alpine

# Label de mainteneur
LABEL mainteneur="Gtko"

# Arguments de build
ARG NODE_VERSION=20

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
    echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \

# Mise à jour initiale et installation des outils nécessaires
    apk update && apk add --no-cache \
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
    tini && \

# Installation de PHP 8.1 et extensions depuis les dépôts edge
    apk add --no-cache \
    php82 \
    php82-dev \
    php82-common \
    php82-gd \
    php82-xmlreader \
    php82-bcmath \
    php82-ctype \
    php82-curl \
    php82-exif \
    php82-iconv \
    php82-intl \
    php82-mbstring \
    php82-opcache \
    php82-openssl \
    php82-pcntl \
    php82-phar \
    php82-session \
    php82-xml \
    php82-xsl \
    php82-zip \
    php82-zlib \
    php82-dom \
    php82-fpm \
    php82-sodium \
    php82-tokenizer \
    php82-pecl-apcu && \
    ln -sf /usr/bin/php82 /usr/bin/php && \

# Configuration du fuseau horaire
    cp /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \

# Installation de nvm et Node.js
    mkdir -p $NVM_DIR && \
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash && \
    . $NVM_DIR/nvm.sh && \
    nvm install $NODE_VERSION && \
    nvm use $NODE_VERSION && \
    nvm alias default $NODE_VERSION && \
    ln -s $NVM_DIR/versions/node/v$NODE_VERSION/bin/node /usr/local/bin/node && \
    ln -s $NVM_DIR/versions/node/v$NODE_VERSION/bin/npm /usr/local/bin/npm && \

# Nettoyer les caches de paquets pour économiser de l'espace
    rm -rf /var/cache/apk/* && \

# Installation de Composer
    curl -sLS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer

# Copie de fichiers de configuration
COPY start-container /usr/local/bin/start-container
COPY php.ini /etc/php82/conf.d/99-vscode.ini

# Configuration des permissions
RUN chmod +x /usr/local/bin/start-container

# Point d'entrée du conteneur
ENTRYPOINT ["start-container"]
