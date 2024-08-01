#!/bin/bash

# Titre et description du script
cmd="dotinstall"
description="Installer, Fabriquer et Mettre a jours votre environement de developpement."
author="Gtko"

source $UTILS_DIR/functions.sh


# Télécharger le script vers un fichier temporaire
temp_file=$(mktemp /tmp/dotinstall.XXXXXX.sh)

wget -q -O "$temp_file" https://github.com/mus-inn/devcontainer-dotworld/releases/latest/download/dotinstall.sh

# Vérification du succès du téléchargement
if [[ $? -ne 0 ]]; then
    echo "Erreur: Échec du téléchargement du script dotinstall.sh."
    exit 1
fi

# Rendre le script temporaire exécutable
chmod +x "$temp_file"

# deplacer au bon endroit

cd $WORKSPACE_DIR

# Exécuter le script téléchargé
source "$temp_file"

sleep 2

# Supprimer le fichier temporaire après l'exécution
rm -f "$temp_file"