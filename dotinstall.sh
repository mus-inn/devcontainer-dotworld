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

# Variables globales
REPO_OWNER="mus-inn"
REPO_NAME="devcontainer-dotworld"

# Répertoire temporaire pour le téléchargement
TEMP_DIR=$(mktemp -d)
trap 'rm -rf "$TEMP_DIR"' EXIT

# Fonction pour obtenir la dernière version du dépôt GitHub
function get_latest_version() {
    local latest_version=$(curl -s "https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/releases/latest" | grep '"tag_name":' | sed -E 's/.*"tag_name": "([^"]+)".*/\1/')
    if [ -z "$latest_version" ]; then
        echo -e "${ERROR} Failed to fetch the latest version."
        exit 1
    fi
    echo "$latest_version"
}

# Fonction pour construire l'URL de téléchargement
function get_download_url() {
    local version=$1
    echo "https://github.com/$REPO_OWNER/$REPO_NAME/archive/refs/tags/$version.tar.gz"
}

# Fonction pour télécharger le fichier
function download_file() {
    local url=$1
    local output=$2

    echo -e "${INFO} Downloading from $url to $output..."

    if command -v wget &> /dev/null; then
        wget -qO "$output" "$url" || { echo -e "${ERROR} wget failed."; exit 1; }
    elif command -v curl &> /dev/null; then
        curl -sL "$url" -o "$output" || { echo -e "${ERROR} curl failed."; exit 1; }
    elif command -v python3 &> /dev/null; then
        python3 -c "import urllib.request; urllib.request.urlretrieve('$url', '$output')" || { echo -e "${ERROR} python3 download failed."; exit 1; }
    elif command -v perl &> /dev/null; then
        perl -e "use LWP::Simple; getstore('$url', '$output')" || { echo -e "${ERROR} perl download failed."; exit 1; }
    else
        echo -e "${ERROR} No suitable download method found. Exiting."
        exit 1
    fi

    if [ ! -f "$output" ]; then
        echo -e "${ERROR} Downloaded file not found: $output"
        exit 1
    fi
}

function updateTerminalShellDevcontainer(){
    if alias updatedevcontainer &>/dev/null; then
        updatedevcontainer
    fi
}

# Fonction pour mettre à jour Dotdev
function update_dotdev() {
    echo -e "${INFO} Updating Dotdev..."
    # Assurer que les fichiers sont déjà téléchargés et mis à jour dans le répertoire .devcontainer/dotdev
    rm -r ./.devcontainer/dotdev
    cp -R $PATH_TO_TEMP_DIR/dotdev ./.devcontainer || { echo -e "${ERROR} Failed to copy dotdev files."; exit 1; }
    updateTerminalShellDevcontainer
    echo -e "${SUCCESS} Dotdev files have been updated successfully!"
}

# Fonction pour créer un nouvel environnement devcontainer
function create_devcontainer() {
    local TEMPLATE_CHOICE=$1
    local APP_NAME=$2
    local STUBS_DIR="$PATH_TO_TEMP_DIR/stubs/stacks/$TEMPLATE_CHOICE"
    local DEST_DIR="./.devcontainer"
    local DOTDEV_DIR="$PATH_TO_TEMP_DIR/dotdev"


    if [ ! -d "$STUBS_DIR" ]; then
        echo -e "${ERROR} Template $TEMPLATE_CHOICE does not exist."
        exit 1
    fi

    rm -r $DEST_DIR

    echo -e "${INFO} Creating new devcontainer environment from $TEMPLATE_CHOICE template..."
    mkdir -p $DEST_DIR
    cp -r $STUBS_DIR/. $DEST_DIR || { echo -e "${ERROR} Failed to copy template files."; exit 1; }

    echo -e "${INFO} Replacing variable ##APP_NAME## with $APP_NAME..."
    find $DEST_DIR -type f -exec sed -i.bak "s/##APP_NAME##/$APP_NAME/g" {} \; || { echo -e "${ERROR} Failed to replace variable."; exit 1; }

    find $DEST_DIR -type f -name "*.bak" -exec rm {} \;

    cp -r $DOTDEV_DIR/. $DEST_DIR/dotdev || { echo -e "${ERROR} Failed to copy template files."; exit 1; }
    updateTerminalShellDevcontainer
    echo -e "${SUCCESS} New devcontainer environment has been created successfully!"
}

# Fonction pour construire une image Docker
function build_docker_image() {
    cd $PATH_TO_TEMP_DIR 
    if [ ! -f "$PATH_TO_TEMP_DIR/build.sh" ]; then
        echo -e "${ERROR} build.sh script not found in the current directory."
        exit 1
    fi

    echo -e "${INFO} Executing build.sh to build Docker image..."
    bash $PATH_TO_TEMP_DIR/build.sh || { echo -e "${ERROR} Docker build script failed."; exit 1; }
    echo -e "${SUCCESS} Docker image built successfully!"
}

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


# Fonction pour obtenir le nom du dépôt Git
get_git_repo_name() {
    # Vérifie si le répertoire courant est un dépôt Git
    if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        # Obtient le nom du dépôt Git
        git_repo_name=$(basename $(git rev-parse --show-toplevel))
        echo "$git_repo_name"
    else
        echo ""
    fi
}

# Fonction pour obtenir le nom du répertoire courant
get_current_directory_name() {
    current_directory_name=$(basename "$PWD")
    echo "$current_directory_name"
}



# Fonction pour afficher les options du menu principal et récupérer le choix utilisateur
function show_main_menu() {
    echo -e "${INFO} Please select an option:"
    echo -e "1) Update Dotdev"
    echo -e "2) Install a devcontainer environment"
    echo -e "3) Build Docker Image"
    echo -e ""

    local CHOICE=$(prompt "${INFO} Enter your choice [1-3]: ")

    case $CHOICE in
        1)
            update_dotdev
            ;;
        2)
            echo -e "${INFO} Calling choose_template..."
            show_stacks
            TEMPLATE=$(choose_template)
            echo -e "${INFO} Template chosen: $TEMPLATE"
            # Détermine le nom de l'application
            git_repo_name=$(get_git_repo_name)
            if [ -n "$git_repo_name" ]; then
                # Si un nom de dépôt Git est trouvé, l'utiliser
                APP_NAME="$git_repo_name"
            else
                # Sinon, utiliser le nom du répertoire courant
                APP_NAME=$(get_current_directory_name)
            fi
            create_devcontainer $TEMPLATE $APP_NAME
            ;;
        3)
            build_docker_image
            ;;
        *)
            echo -e "${ERROR} Invalid choice. Exiting."
            exit 1
            ;;
    esac
}

function show_stacks() {
    local index=0
    local template_options=()

    for dir in $PATH_TO_TEMP_DIR/stubs/stacks/*; do
        if [ -d "$dir" ]; then
            local template_name=$(basename "$dir")
            local description="Aucune description disponible"

            # Vérifier si le fichier README existe et lire tout le contenu
            if [ -f "$dir/describ" ]; then
                description=$(tr '\n' ' ' < "$dir/describ" | sed 's/  */ /g')  # Remplace les nouvelles lignes par des espaces
            fi

            local NUMERO=$((index + 1))
            echo -e "$NUMERO ) $template_name - $description"
            template_options+=("$template_name")
            index=$((index + 1))
        fi
    done
}

# Fonction pour afficher les options de template et récupérer le choix utilisateur
function choose_template() {
    local index=1
    local template_options=()
    
    for dir in $PATH_TO_TEMP_DIR/stubs/stacks/*; do
        if [ -d "$dir" ]; then
            local template_name=$(basename "$dir")
            template_options+=("$template_name")
            index=$((index + 1))
        fi
    done

    if [ ${#template_options[@]} -eq 0 ]; then
        echo -e "${ERROR} No templates found in $PATH_TO_TEMP_DIR/stubs/stacks/. Exiting."
        exit 1
    fi


    local TEMPLATE_CHOICE=$(prompt "${INFO} Enter your template choice [1-${#template_options[@]}]: ")

    if [[ ! "$TEMPLATE_CHOICE" =~ ^[1-9][0-9]*$ ]] || [ "$TEMPLATE_CHOICE" -lt 1 ] || [ "$TEMPLATE_CHOICE" -gt "${#template_options[@]}" ]; then
        echo -e "${ERROR} Invalid choice. Exiting."
        exit 1
    fi

    local TEMPLATE=${template_options[$((TEMPLATE_CHOICE-1))]}
    echo $TEMPLATE
}



clear
#download latest version
LATEST_VERSION=$(get_latest_version)
DOWNLOAD_URL=$(get_download_url $LATEST_VERSION)
TEMP_DIR_NAME="$REPO_NAME-$LATEST_VERSION"
PATH_TO_TEMP_DIR="$TEMP_DIR/$TEMP_DIR_NAME"
download_file $DOWNLOAD_URL $TEMP_DIR/$REPO_NAME.tar.gz
tar -xzf $TEMP_DIR/$REPO_NAME.tar.gz -C $TEMP_DIR
echo -e "${SUCCESS} Downloaded and extracted the latest version $LATEST_VERSION."

sleep 1
clear

echo -e "Welcome"
echo -e "______      _  _____          _        _ _ "
echo -e "|  _  \    | ||_   _|        | |      | | |"
echo -e "| | | |___ | |_ | | _ __  ___| |_ __ _| | |"
echo -e "| | | / _ \| __|| ||  _ \/ __| __/ _  | | |"
echo -e "| |/ / (_) | |__| || | | \__ \ || (_| | | |"
echo -e "|___/ \___/ \__\___/_| |_|___/\__\__,_|_|_|"                                           
echo -e ""
echo -e "by Dotworld"
echo -e ""


# Exécution principale
show_main_menu
