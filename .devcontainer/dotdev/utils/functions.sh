#!/bin/bash

# Fonction pour afficher des messages formatés avec gum
print_message() {
    local message=$1
    local emoji=$2
    gum style --border normal --margin "1" --padding "1" --border-foreground 212 --foreground 51 "${emoji} ${message}"
}

# Fonction pour exécuter une commande avec une barre de progression
run_with_spinner() {
    local title=$1
    shift
    local cmd=$@

    gum spin --title "$title" --spinner dot -- bash -c "$cmd"
}

# Fonction pour afficher un message de succès
complete() {
    gum style --border normal --margin "1" --padding "1" --border-foreground 212 --foreground 2 "🎉 $1"
    sleep 2
}
