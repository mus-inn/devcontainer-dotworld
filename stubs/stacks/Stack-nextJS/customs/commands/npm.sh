#!/bin/bash

# Titre et description du script
cmd="npm"
description="Tous ce qu'il te faut pour dev avec nextJS"
author="Gtko"

source $UTILS_DIR/functions.sh

# Codes de couleurs
RESET='\033[0m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'


# Fonction pour afficher le menu de sélection avec `gum`
show_menu() {
    local choice

    choice=$(gum choose \
        "Démarrer le serveur de développement local" \
        "Compiler le site de production" \
        "Lancer le serveur local basé sur un build" \
        "Exécuter 'npm run build' et 'npm run start'" \
        "Quitter" \
    )

    case $choice in
        "Démarrer le serveur de développement local")
            execute_command 1
            ;;
        "Compiler le site de production")
            execute_command 2
            ;;
        "Lancer le serveur local basé sur un build")
            execute_command 3
            ;;
        "Exécuter 'npm run build' et 'npm run start'")
            execute_command 4
            ;;
        "Quitter")
            print_message "Quitter" "❌"
            exit 0
            ;;
    esac
}

# Fonction pour exécuter les commandes basées sur l'entrée utilisateur
execute_command() {
    case $1 in
        1)
            print_message "Démarrage du serveur de développement local..." "🔄"
            npm run dev
            ;;
        2)
            print_message "Compilation du site de production..." "🔄"
            npm run build
            ;;
        3)
            print_message "Lancement du serveur local basé sur un build..." "🔄"
            npm run start
            ;;
        4)
            print_message "Exécution de 'npm run build' et 'npm run start'..." "🔄"
            npm run preview
            ;;
        *)
            print_message "Choix invalide" "❌"
            ;;
    esac
}

# Fonction pour demander une commande à l'utilisateur via `gum`
prompt_user() {
    local option
    option=$(gum choose \
        "dev" \
        "build" \
        "start" \
        "preview" \
    )

    case $option in
        "dev")
            print_message "Démarrage du serveur de développement local..." "🔄"
            npm run dev
            ;;
        "build")
            print_message "Compilation du site de production..." "🔄"
            npm run build
            ;;
        "start")
            print_message "Lancement du serveur local basé sur un build..." "🔄"
            npm run start
            ;;
        "preview")
            print_message "Exécution de 'npm run build' et 'npm run start'..." "🔄"
            npm run preview
            ;;
        *)
            print_message "Commande invalide : $option" "❌"
            exit 1
            ;;
    esac
}

# Si un argument est passé, exécutez directement la commande correspondante
if [ $# -eq 1 ]; then
    case $1 in
        dev)
            print_message "Démarrage du serveur de développement local..." "🔄"
            npm run dev
            ;;
        build)
            print_message "Compilation du site de production..." "🔄"
            npm run build
            ;;
        start)
            print_message "Lancement du serveur local basé sur un build..." "🔄"
            npm run start
            ;;
        preview)
            print_message "Exécution de 'npm run build' et 'npm run start'..." "🔄"
            npm run preview
            ;;
        *)
            print_message "Commande invalide : $1" "❌"
            exit 1
            ;;
    esac
    exit 0
fi

# Affichage du menu et traitement de l'entrée utilisateur
while true; do
    show_menu
    echo ""
    gum spin --title="En attente d'une action..." -- sleep 1
done
