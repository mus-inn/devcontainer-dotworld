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
    gum 

# Install Oh My Zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Create a new user 'vscode' with sudo privileges
RUN useradd -m -s /bin/bash vscode && \
    usermod -aG wheel vscode && \
    echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Set working directory
WORKDIR /var/www/html
