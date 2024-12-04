#!/bin/bash

# Méthode pour afficher "DotStarter" en gros
display_title() {
    gum style \
        --foreground "#FFA500" \
        --border double \
        --align center \
        --margin "1 2" \
        --padding "2 4" \
        "DotStarter"
}

# Méthode pour installer le projet backend
install_backend() {
    gum style --foreground "#00FF00" "Lancement de l'installation du projet backend..."
    SCRIPT_PATH="./dotinstall/scripts/backend/install-backend.sh"
    if [ -f "$SCRIPT_PATH" ]; then
        chmod +x "$SCRIPT_PATH"  # S'assurer que le script est exécutable
        "$SCRIPT_PATH"
    else
        gum style --foreground "#FF0000" "Erreur : le script '$SCRIPT_PATH' est introuvable."
    fi
}

# Méthode pour installer le projet frontend
install_frontend() {
    gum style --foreground "#00FF00" "Lancement de l'installation du projet frontend..."
    # Remplacez par le chemin de votre script pour le frontend, si nécessaire.
    SCRIPT_PATH="./dotinstall/frontend/install-frontend.sh"
    if [ -f "$SCRIPT_PATH" ]; then
        chmod +x "$SCRIPT_PATH"  # S'assurer que le script est exécutable
        "$SCRIPT_PATH"
    else
        gum style --foreground "#FF0000" "Erreur : le script '$SCRIPT_PATH' est introuvable."
    fi
}

# Méthode pour exécuter Dotinstall
run_dotinstall() {
    gum style --foreground "#00FF00" "Exécution de Run Dotinstall..."
    SCRIPT_PATH="./dotinstall.sh"
    if [ -f "$SCRIPT_PATH" ]; then
        chmod +x "$SCRIPT_PATH"  # S'assurer que le script est exécutable
        "$SCRIPT_PATH"
    else
        gum style --foreground "#FF0000" "Erreur : le script '$SCRIPT_PATH' est introuvable."
    fi
}

# Méthode principale pour afficher le menu et gérer les choix
main_menu() {
    # Afficher le menu avec Gum
    CHOICE=$(gum choose "Install Backend Project" "Install Frontend Project" "Run Dotinstall")

    # Gérer le choix
    case "$CHOICE" in
        "Install Backend Project")
            install_backend
            ;;
        "Install Frontend Project")
            install_frontend
            ;;
        "Run Dotinstall")
            run_dotinstall
            ;;
        *)
            gum style --foreground "#FF0000" "Option invalide. Aucune action effectuée."
            ;;
    esac
}

# Appeler les fonctions
display_title
main_menu
