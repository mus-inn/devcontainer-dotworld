# Utiliser l'image de base fournie
FROM chdotworld/dotworld:node18-alpine

# Label de mainteneur
LABEL mainteneur="Gtko"

# Définir le répertoire de travail
WORKDIR /var/www/html

# Variables d'environnement
ENV TZ=Europe/Paris

# Passer à l'utilisateur root pour les installations
USER root

# Mise à jour et installation des outils nécessaires
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories && \
    echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
    echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
    apk update && apk add --no-cache \
    mysql-client \
    tini \
    php81 \
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
    ln -sf /usr/bin/php81 /usr/bin/php && \
    # Configuration du fuseau horaire
    cp /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
    # Installation de Composer
    curl -sLS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer && \
    # Nettoyage des caches et des fichiers temporaires
    rm -rf /var/cache/apk/*

# Copie des fichiers de configuration
COPY start-container /usr/local/bin/start-container
COPY php.ini /etc/php81/conf.d/99-vscode.ini

# Configuration des permissions
RUN chmod +x /usr/local/bin/start-container

# Point d'entrée du conteneur
ENTRYPOINT ["start-container"]