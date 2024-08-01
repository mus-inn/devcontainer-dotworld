# Utiliser une image de base plus légère
FROM ubuntu:jammy

LABEL maintainer="Gtko"

ARG WWWGROUP=1000
ARG DEBIAN_FRONTEND=noninteractive

# Configurer le répertoire de travail
WORKDIR /var/www/html

# Définir le fuseau horaire et les options de configuration pour éviter les interactions
ENV TZ=Europe/Paris

# Passer à l'utilisateur root pour les installations
USER root

# Remplacer le shell par défaut
RUN ln -sf /bin/dash /bin/sh

# Mise à jour et installation des outils nécessaires
RUN apt-get update \
    && apt-get install -y --no-install-recommends wget nano zsh sudo figlet curl git unzip \
    net-tools dnsutils gnupg ca-certificates \
    gzip tar fswatch gosu \
    && curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null \
    && curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg \
    && echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list \
    && apt-get update \
    && apt-get install -y docker-ce gum \
    && apt-get -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Configuration de l'utilisateur et du groupe
RUN groupadd --force -g $WWWGROUP vscode && \
    useradd -ms /bin/bash --no-user-group -g $WWWGROUP -u 1337 vscode



# Copier le script de démarrage
COPY start-container /usr/local/bin/start-container

# Rendre le script exécutable
RUN chmod +x /usr/local/bin/start-container

# Exécution du conteneur
ENTRYPOINT ["start-container"]