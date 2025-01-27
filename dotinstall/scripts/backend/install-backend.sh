#!/bin/bash

# Méthode pour afficher le menu interactif
show_backend_menu() {
    gum style --foreground "#00FF00" --bold "Sélectionnez les composants backend à installer :"
    gum choose --no-limit \
        "Install Laravel" \
        "Install Musine Client" \
        "Install LTH"
}

# Méthode pour installer Laravel
install_laravel() {
    echo "Installation de Laravel..."
    SCRIPT_PATH="./dotinstall/scripts/backend/install-laravel.sh"
    if [ -f "$SCRIPT_PATH" ]; then
        chmod +x "$SCRIPT_PATH"
        "$SCRIPT_PATH"
    else
        echo "Erreur : le script '$SCRIPT_PATH' est introuvable."
    fi
}

# Méthode pour installer Musine Client
install_musine_client() {
    echo "Installation de Musine Client..."
    SCRIPT_PATH="./dotinstall/scripts/backend/install-musine-client.sh"
    if [ -f "$SCRIPT_PATH" ]; then
        chmod +x "$SCRIPT_PATH"
        "$SCRIPT_PATH"
    else
        echo "Erreur : le script '$SCRIPT_PATH' est introuvable."
    fi
}

# Méthode pour installer LTH
install_lth() {
    echo "Installation de LTH..."
    SCRIPT_PATH="./dotinstall/scripts/backend/install-lth.sh"
    if [ -f "$SCRIPT_PATH" ]; then
        chmod +x "$SCRIPT_PATH"
        "$SCRIPT_PATH"
    else
        echo "Erreur : le script '$SCRIPT_PATH' est introuvable."
    fi
}

# Méthode principale pour exécuter les choix
process_selection() {
    local options="$1"

    # Vérification si des options ont été sélectionnées
    if [ -z "$options" ]; then
        echo "Aucune option sélectionnée. Opération annulée."
        exit 0
    fi

    # Afficher les choix sélectionnés
    echo "Options sélectionnées :"
    while IFS= read -r option; do
        echo "-- $option"
    done <<< "$options"

    # Confirmation générale
    read -p "Êtes-vous sûr de vouloir lancer les commandes pour ces actions ? (oui/non) : " confirmation
    if [[ "$confirmation" != "oui" ]]; then
        echo "Opération annulée."
        exit 0
    fi

    # Exécuter les commandes une par une
    while IFS= read -r option; do
        case "$option" in
            "Install Laravel")
                install_laravel
                ;;
            "Install Musine Client")
                install_musine_client
                ;;
            "Install LTH")
                install_lth
                ;;
            
        esac
    done <<< "$options"

    echo "Toutes les commandes ont été exécutées avec succès."
}

# Appel des méthodes
selected_options=$(show_backend_menu)
process_selection "$selected_options"
