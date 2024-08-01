#!/bin/bash

# gum if already installed
if command -v gum &> /dev/null
then
    echo "gum est déjà installé"
    echo "gum version: $(gum --version)"
else    

# Définir la version de gum à installer
GUM_VERSION="0.14.3"

# Définir l'URL de téléchargement
GUM_URL="https://github.com/charmbracelet/gum/releases/download/v${GUM_VERSION}/gum_${GUM_VERSION}_Linux_x86_64.tar.gz"

# Téléchargez le binaire de gum
wget -q $GUM_URL -O /tmp/gum_${GUM_VERSION}_Linux_x86_64.tar.gz

# Décompressez l'archive
tar -xf /tmp/gum_${GUM_VERSION}_Linux_x86_64.tar.gz -C /tmp

# Rendez le binaire exécutable
chmod +x /tmp/gum_${GUM_VERSION}_Linux_x86_64/gum

# Déplacez le binaire dans un répertoire inclus dans le PATH
sudo mv /tmp/gum_${GUM_VERSION}_Linux_x86_64/gum /usr/local/bin/gum

#clean
rm -rf /tmp/gum_${GUM_VERSION}_Linux_x86_64
rm -rf /tmp/gum_${GUM_VERSION}_Linux_x86_64.tar.gz

# Vérifiez l'installation
if command -v gum &> /dev/null
then
    echo "gum installé avec succès"
    echo "gum version: $(gum --version)"
else
    echo "Échec de l'installation de gum"
    exit 1
fi

fi
