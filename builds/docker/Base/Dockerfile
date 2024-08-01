# Définir des arguments de build pour l'architecture et le système d'exploitation cibles
ARG TARGETOS
ARG TARGETARCH

# Utiliser l'image de base fournie
FROM --platform=$BUILDPLATFORM alpine:latest

# Label de mainteneur
LABEL maintainer="Dotworld"

# Installer les dépendances nécessaires et créer un utilisateur
RUN apk update && apk upgrade && \
    apk add --no-cache \
    bash \
    curl \
    nano \
    shadow \
    figlet \
    gum && \
    # Créer un utilisateur vscode
    adduser -D -g "Visual Studio Code" vscode && \
    # Assurez-vous que l'utilisateur a accès au répertoire de travail
    mkdir -p /var/www/html && \
    chown -R vscode:vscode /var/www/html && \
    # Nettoyer le cache pour réduire la taille de l'image
    rm -rf /var/cache/apk/*

# Définir le répertoire de travail
WORKDIR /var/www/html

# Passer à l'utilisateur vscode
USER vscode

# Revenir à l'utilisateur root si nécessaire pour d'autres instructions
# USER root
