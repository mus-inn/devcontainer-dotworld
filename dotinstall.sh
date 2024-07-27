#!/bin/bash

# Couleurs et emojis
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

INFO="${BLUE}ℹ️${NC}"
SUCCESS="${GREEN}✅${NC}"
WARNING="${YELLOW}⚠️${NC}"
ERROR="${RED}❌${NC}"

# URL du dépôt GitHub
GITHUB_URL="https://github.com/yourusername/yourrepo/releases/latest/download/dotdev.tar.gz"

# Fonction d'affichage du message d'usage
function usage() {
    echo -e "${INFO} Usage: $0"
    exit 1
}

# Fonction pour demander une entrée utilisateur avec une invite colorée
function prompt() {
    local PROMPT_MESSAGE=$1
    read -p "$(echo -e $PROMPT_MESSAGE)" INPUT
    echo $INPUT
}

# Fonction d'installation ou mise à jour de dotdev
function install_or_update_dotdev() {
    echo -e "${INFO} Downloading and extracting dotdev files..."
    mkdir -p ./.devcontainer/dotdev
    wget -qO- $GITHUB_URL | tar xz -C ./.devcontainer/dotdev || { echo -e "${ERROR} Failed to download or extract files."; exit 1; }
    echo -e "${SUCCESS} Dotdev files have been installed/updated successfully!"
}

# Fonction pour créer un nouvel environnement devcontainer
function create_devcontainer() {
    local TEMPLATE_CHOICE=$1
    local APP_NAME=$2
    local STUBS_DIR="./stubs/stacks/$TEMPLATE_CHOICE"
    local DEST_DIR="./.devcontainer"
    local DOTDEV_DIR="./dotdev"

    # Vérifier l'existence du répertoire de stubs
    if [ ! -d "$STUBS_DIR" ]; then
        echo -e "${ERROR} Template $TEMPLATE_CHOICE does not exist."
        exit 1
    fi

    # Copier les fichiers de stubs
    echo -e "${INFO} Creating new devcontainer environment from $TEMPLATE_CHOICE template..."
    mkdir -p $DEST_DIR
    cp -r $STUBS_DIR/. $DEST_DIR || { echo -e "${ERROR} Failed to copy template files."; exit 1; }

    # Remplacement de la variable ##APP_NAME##
    echo -e "${INFO} Replacing variable ##APP_NAME## with $APP_NAME..."
    find $DEST_DIR -type f -exec sed -i.bak "s/##APP_NAME##/$APP_NAME/g" {} \; || { echo -e "${ERROR} Failed to replace variable."; exit 1; }

    # Nettoyage des fichiers de backup générés par sed
    find $DEST_DIR -type f -name "*.bak" -exec rm {} \;

    cp -r $DOTDEV_DIR/. $DEST_DIR/dotdev || { echo -e "${ERROR} Failed to copy template files."; exit 1; }

    echo -e "${SUCCESS} New devcontainer environment has been created successfully!"
}

# Affichage du menu
echo -e "${INFO} Please select an option:"
echo -e ""
echo -e "1) Install or Update dotdev"
echo -e "2) Create a new devcontainer environment"
echo -e ""
CHOICE=$(prompt "${INFO} Enter your choice [1-2]: ")

case $CHOICE in
    1)
        install_or_update_dotdev
        ;;
    2)
        echo -e "${INFO} Please select a template:"
        echo "1) Tall"
        echo "2) NextJS"
        echo "3) GoLang"
        echo "4) Starter"
        TEMPLATE_CHOICE=$(prompt "${INFO} Enter your template choice [1-3]: ")

        case $TEMPLATE_CHOICE in
            1)
                TEMPLATE="Tall"
                ;;
            2)
                TEMPLATE="NextJS"
                ;;
            3)
                TEMPLATE="GoLang"
                ;;
            4)
                TEMPLATE="Starter"
                ;;    
            *)
                echo -e "${ERROR} Invalid choice. Exiting."
                exit 1
                ;;
        esac

        APP_NAME=$(prompt "${INFO} Enter the APP_NAME: ")

        create_devcontainer $TEMPLATE $APP_NAME
        ;;
    *)
        echo -e "${ERROR} Invalid choice. Exiting."
        exit 1
        ;;
esac
