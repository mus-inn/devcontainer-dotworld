#!/bin/bash

# Répertoire contenant les configurations et les scripts
export SCRIPT_DIR=$(dirname "$0")
export SCRIPT_DIR=$(cd "$SCRIPT_DIR" && pwd)
# Chemin complet
full_path=$(dirname $(dirname "$SCRIPT_DIR"))
# Obtenir le répertoire parent deux niveaux au-dessus
export WORKSPACE_DIR=$(dirname "$full_path")
export DEVCONTAINER_DIR="${WORKSPACE_DIR}/.devcontainer"
export DOTDEV_DIR="${DEVCONTAINER_DIR}/dotdev"
export COMMANDS_DIR="${DOTDEV_DIR}/commands"
export CUSTOM_DIR="${DEVCONTAINER_DIR}/customs"
export CUSTOM_COMMANDS_DIR="${CUSTOM_DIR}/commands"
export UTILS_DIR="${DOTDEV_DIR}/utils"
export CONFIG_DIR="${UTILS_DIR}/stubs"

export APP_NAME=$(basename `git rev-parse --show-toplevel`)


# Utilisateur courant et root
USERS=("vscode" "root")

for USER in "${USERS[@]}"; do
    HOME_DIR="/home/$USER"
    if [ "$USER" == "root" ]; then
        HOME_DIR="/root"
    fi

    # Copie des fichiers .bashrc et .zshrc
    sudo cp "$CONFIG_DIR/.bashrc" "$HOME_DIR/.bashrc"
    sudo cp "$CONFIG_DIR/.zshrc" "$HOME_DIR/.zshrc"

    #fix permsission executable
    sudo chmod +x "$UTILS_DIR/welcome.sh"

    # Ajouter les variable et scripts .bashrc et .zshrc
    echo "export WORKSPACE_DIR=\"$WORKSPACE_DIR\"" >> "$HOME_DIR/.bashrc"
    echo "export WORKSPACE_DIR=\"$WORKSPACE_DIR\"" >> "$HOME_DIR/.zshrc"

    echo "export DEVCONTAINER_DIR=\"$DEVCONTAINER_DIR\"" >> "$HOME_DIR/.bashrc"
    echo "export DEVCONTAINER_DIR=\"$DEVCONTAINER_DIR\"" >> "$HOME_DIR/.zshrc"

	  echo "export DOTDEV_DIR=\"$DOTDEV_DIR\"" >> "$HOME_DIR/.bashrc"
    echo "export DOTDEV_DIR=\"$DOTDEV_DIR\"" >> "$HOME_DIR/.zshrc"

	  echo "export COMMANDS_DIR=\"$COMMANDS_DIR\"" >> "$HOME_DIR/.bashrc"
    echo "export COMMANDS_DIR=\"$COMMANDS_DIR\"" >> "$HOME_DIR/.zshrc"

	  echo "export CUSTOM_DIR=\"$CUSTOM_DIR\"" >> "$HOME_DIR/.bashrc"
    echo "export CUSTOM_DIR=\"$CUSTOM_DIR\"" >> "$HOME_DIR/.zshrc"

	  echo "export CUSTOM_COMMANDS_DIR=\"$CUSTOM_COMMANDS_DIR\"" >> "$HOME_DIR/.bashrc"
    echo "export CUSTOM_COMMANDS_DIR=\"$CUSTOM_COMMANDS_DIR\"" >> "$HOME_DIR/.zshrc"

	  echo "export APP_NAME=\"$APP_NAME\"" >> "$HOME_DIR/.bashrc"
    echo "export APP_NAME=\"$APP_NAME\"" >> "$HOME_DIR/.zshrc"

    echo "export UTILS_DIR=\"$UTILS_DIR\"" >> "$HOME_DIR/.bashrc"
    echo "export UTILS_DIR=\"$UTILS_DIR\"" >> "$HOME_DIR/.zshrc"

    echo "export CONFIG_DIR=\"$CONFIG_DIR\"" >> "$HOME_DIR/.bashrc"
    echo "export CONFIG_DIR=\"$CONFIG_DIR\"" >> "$HOME_DIR/.zshrc"

    echo "source ${UTILS_DIR}/.sharerc" >> "$HOME_DIR/.bashrc"
    echo "source ${UTILS_DIR}/.sharerc" >> "$HOME_DIR/.zshrc"

done

source ${UTILS_DIR}/install_gum.sh
source ${CUSTOM_DIR}/install.sh


# Copie du makefile si il n'existe pas
if [ ! -f "$WORKSPACE_DIR/makefile" ]; then
  cp "$CONFIG_DIR/makefile" "$WORKSPACE_DIR/makefile"
  sed -i "s/##APP_NAME##/\"${APP_NAME}\"/g" "$WORKSPACE_DIR/makefile"
fi

echo "Configuration des shells installée avec succès."

