#!/bin/bash

cd $WORKSPACE_DIR
git config --global --add safe.directory $WORKSPACE_DIR

# Vérifiez si la police est installée
if [ ! -f "/usr/share/figlet/fonts/ANSI_Shadow.flf" ]; then
    # Téléchargez le pack de polices
    wget -q https://github.com/xero/figlet-fonts/archive/refs/heads/master.zip -O figlet-fonts-master.zip

    # Décompressez le fichier ZIP
    unzip -q figlet-fonts-master.zip

    # Créez le répertoire des polices si nécessaire
    sudo mkdir -p /usr/share/figlet/fonts > /dev/null 2>&1

    # Déplacez les polices dans le répertoire figlet
    sudo mv figlet-fonts-master/* /usr/share/figlet/fonts/ > /dev/null 2>&1

    # Supprimez les fichiers temporaires
    rm -rf figlet-fonts-master.zip figlet-fonts-master > /dev/null 2>&1
fi

clear

# Définir la couleur (vert dans cet exemple)
COLOR_GREEN='\033[0;32m'
COLOR_RESET='\033[0m'

# Détermine le type de shell utilisé
if [ -n "$BASH_VERSION" ]; then
    shell_type="Bash"
elif [ -n "$ZSH_VERSION" ]; then
    shell_type="Zsh"
else
    shell_type=$(basename "$SHELL")
fi

# Récupérer le nom du projet à partir de git si la variable d'environnement CODESPACE_NAME n'existe pas
project=$(basename `git rev-parse --show-toplevel`)

# Récupérer le nom d'utilisateur GitHub si disponible
if [ -z "$GITHUB_USER" ]; then
    GITHUB_USER=$(git config user.name)
fi

clear

# Affiche le message de bienvenue
echo -e "${COLOR_GREEN}Welcome ${GITHUB_USER:-} to"
echo ""
# Vérifiez si figlet est installé
if ! command -v figlet &> /dev/null
then
    echo -e "${COLOR_GREEN}$project"
else
    figlet -f /usr/share/figlet/fonts/'ANSI Shadow.flf' -w 200 "$project"    
fi


echo -e "By Dotworld"
echo -e "Shell $shell_type"
echo -e "${COLOR_RESET}"

# Affiche les valeurs
echo -e "\033[1;34mNos valeurs:\033[0m"
echo -e "😎 Décontracté mais professionnel - 🚀 Maintenant ou jamais ! Plus tard, c'est jamais !"
echo -e "🧠 Si t'as besoin d'expliquer, c'est qu'il y a du cafouillage ! - 💪 On, c'est le super-héros"
echo -e "🎯 Le mieux est l’ennemi du bien - 🗣️ La parole est d'or - 🕵️ On doute pour mieux avancer"
echo -e ""
echo -e "🔗 \033[1;33mhttps://tinyurl.com/valeurs-dotworld\033[0m - Nos valeurs"
echo -e ""


# Inclure le contenu personnalisé à partir d'un fichier externe
if [ -f "$CUSTOM_DIR/welcome.sh" ]; then
    source "$CUSTOM_DIR/welcome.sh"
fi

# Fin du message
echo -e ""
