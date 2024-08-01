#!/bin/bash

# Fonction pour exécuter une commande dans un TTY simulé
run_with_script() {
    local command="$1"
    local input="$2"

    # Utiliser `script` pour exécuter la commande dans un environnement TTY
    script -q -c "$command" /dev/null <<< "$input"
}

# Vérification de la connexion initiale
output=$(run_with_script "docker login" "")

# Vérifier l'état de connexion en analysant la sortie
if [[ "$output" == *"login success"* ]]; then
    echo "L'utilisateur est déjà connecté. Continuons avec le script."
else
    echo "L'utilisateur n'est pas connecté, tentative de connexion..."
fi    