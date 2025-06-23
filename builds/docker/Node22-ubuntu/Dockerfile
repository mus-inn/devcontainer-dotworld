# Définir des arguments de build pour l'architecture et le système d'exploitation cibles
ARG TARGETOS
ARG TARGETARCH

# Utiliser l'image de base fournie
FROM --platform=$BUILDPLATFORM chdotworld/dotworld:base-ubuntu

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
ENV DEBIAN_FRONTEND=noninteractive

# Passer à l'utilisateur root pour les installations
USER root

# Installer les outils nécessaires
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    gcc \
    g++ \
    make \
    cmake \
    pkg-config && \
    # Configuration du fuseau horaire
    ln -sf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN mkdir -p $NVM_DIR && \
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash && \
    . $NVM_DIR/nvm.sh && \
    nvm install $NODE_VERSION && \
    nvm use $NODE_VERSION && \
    nvm alias default $NODE_VERSION && \
    ln -s $NVM_DIR/versions/node/v*/bin/node /usr/local/bin/node && \
    ln -s $NVM_DIR/versions/node/v*/bin/npm /usr/local/bin/npm && \
    corepack enable && \
    corepack prepare yarn@stable --activate && \
    yarn --version && \
    ln -s $NVM_DIR/versions/node/v*/bin/yarn /usr/local/bin/yarn && \
    rm -rf /var/lib/apt/lists/* /root/.npm /root/.nvm /root/.yarn


    # Nettoyer les caches de paquets
RUN apt-get remove -y gcc g++ make cmake pkg-config && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /root/.npm /root/.nvm

# Copier le script de démarrage et définir les permissions
COPY start-container /usr/local/bin/start-container
RUN chmod +x /usr/local/bin/start-container

# Point d'entrée du conteneur
ENTRYPOINT ["start-container"]