# Utiliser l'image de base fournie
FROM chdotworld/dotworld:base-alpine

# Label de mainteneur
LABEL mainteneur="Gtko"

# Arguments de build
ARG NODE_VERSION=22

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
    libxml2-dev \
    curl-dev \
    openssl-dev \
    zlib-dev \
    wget \
    tzdata \
    docker-cli \
    coreutils \
    oniguruma-dev \
    tini && \

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
    rm -rf /var/cache/apk/*

# Copie de fichiers de configuration
COPY start-container /usr/local/bin/start-container

# Configuration des permissions
RUN chmod +x /usr/local/bin/start-container

# Point d'entrée du conteneur
ENTRYPOINT ["start-container"]
