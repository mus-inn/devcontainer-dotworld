FROM alpine:latest

LABEL maintainer="Dotworld"

# Install necessary dependencies
RUN apk update && apk upgrade && \
    apk add --no-cache \
    bash \
    curl \
    zsh \
    nano \
    git \
    sudo \
    shadow \
    figlet \
    gum && \

# Create a new user 'vscode' with sudo privileges
    useradd -m -s /bin/bash vscode && \
    echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    usermod -aG wheel vscode

# Install Oh My Zsh
USER vscode
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Set working directory
WORKDIR /var/www/html

# Switch back to root to apply any necessary configurations
USER root
