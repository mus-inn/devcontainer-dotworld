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

# Installer les outils nécessaires
RUN apk update && apk add --no-cache \
    bash \
    curl \
    gcc \
    g++ \
    make \
    cmake \
    pkgconf \
    libxml2-dev \
    libffi-dev \
    openssl-dev \
    zlib-dev \
    tzdata \
    docker-cli \
    coreutils \
    oniguruma-dev \
    tini && \
    # Configuration du fuseau horaire
    cp /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
    && mkdir -p $NVM_DIR && \
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash && \
    . $NVM_DIR/nvm.sh && \
    nvm install $NODE_VERSION && \
    nvm use $NODE_VERSION && \
    nvm alias default $NODE_VERSION && \
    ln -s $NVM_DIR/versions/node/v$NODE_VERSION/bin/node /usr/local/bin/node && \
    ln -s $NVM_DIR/versions/node/v$NODE_VERSION/bin/npm /usr/local/bin/npm && \
    # Nettoyer les caches de paquets
    apk del gcc g++ make cmake pkgconf libxml2-dev libffi-dev openssl-dev zlib-dev && \
    rm -rf /var/cache/apk/* /root/.npm /root/.nvm

# Copier le script de démarrage et définir les permissions
COPY start-container /usr/local/bin/start-container
RUN chmod +x /usr/local/bin/start-container

# Point d'entrée du conteneur
ENTRYPOINT ["start-container"]

# Configuration de l'heure pour le conteneur
ENV TZ=Europe/Paris