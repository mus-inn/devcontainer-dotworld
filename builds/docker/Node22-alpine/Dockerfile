# Définir des arguments de build pour l'architecture et le système d'exploitation cibles
ARG TARGETOS
ARG TARGETARCH

# Utiliser l'image Node 22 Alpine officielle comme base
FROM --platform=$BUILDPLATFORM node:22-alpine

# Label de mainteneur
LABEL maintainer="Dotworld"

# Arguments de build
ARG NODE_VERSION=22

# Définir le répertoire de travail
WORKDIR /var/www/html

# Variables d'environnement
ENV TZ=Europe/Paris
ENV NVM_DIR=/usr/local/nvm
ENV NODE_VERSION=$NODE_VERSION

# Installer les outils nécessaires (équivalents Alpine)
RUN apk update && apk upgrade && \
    apk add --no-cache \
    bash \
    curl \
    nano \
    figlet \
    docker-cli \
    git \
    openssh-client \
    make \
    cmake \
    pkgconfig \
    python3 \
    build-base && \
    # Configurer le fuseau horaire
    ln -sf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
    # Activer corepack et préparer yarn
    corepack enable && \
    corepack prepare yarn@1.22 --activate && \
    yarn --version

# Nettoyage
RUN rm -rf /var/cache/apk/* /root/.npm /root/.yarn

# Copier le script de démarrage et définir les permissions
COPY start-container /usr/local/bin/start-container
RUN chmod +x /usr/local/bin/start-container

# Point d'entrée du conteneur
ENTRYPOINT ["start-container"]

