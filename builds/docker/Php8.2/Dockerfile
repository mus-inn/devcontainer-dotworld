# Utiliser l'image de base fournie
FROM chdotworld/dotworld:node22-alpine

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
    php82 \
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
    # Installation de Composer
    curl -sLS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer && \
    # Nettoyage des caches et des fichiers temporaires
    rm -rf /var/cache/apk/*

# Copie des fichiers de configuration
COPY start-container /usr/local/bin/start-container
COPY php.ini /etc/php82/conf.d/99-vscode.ini

# Configuration des permissions
RUN chmod +x /usr/local/bin/start-container

# Point d'entrée du conteneur
ENTRYPOINT ["start-container"]