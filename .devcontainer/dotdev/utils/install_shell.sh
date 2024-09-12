#!/bin/bash

# Répertoire contenant les configurations et les scripts
# Répertoire contenant les configurations et les scripts
export SCRIPT_DIR=$(dirname "$0")
export SCRIPT_DIR=$(cd "$SCRIPT_DIR" && pwd)
echo -e "Script directory: $SCRIPT_DIR"
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

git config --global --add safe.directory $WORKSPACE_DIR
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


#Interactive shell
sudo chmod +x ${UTILS_DIR}/interactive_shell.sh

#fix permsission executable
sudo chmod +x "$UTILS_DIR/welcome.sh"

#Fix des permissions
sudo chown -R root:root $WORKSPACE_DIR

source ${CUSTOM_DIR}/install.sh

# Ajouter le makefile au .gitignore s'il n'y est pas déjà
GITIGNORE_FILE="${WORKSPACE_DIR}/.gitignore"
if [ -f "$GITIGNORE_FILE" ]; then
    if ! grep -q "^Makefile$" "$GITIGNORE_FILE"; then
        echo "Makefile" >> "$GITIGNORE_FILE"
        # Vider le cache Git afin que le gitIgnore soit pris en compte
        git rm --cached "$WORKSPACE_DIR/Makefile"
    fi
fi

# Check if Makefile exists before copying
if [ ! -f "$WORKSPACE_DIR/Makefile" ]; then
    cp "$CONFIG_DIR/Makefile" "$WORKSPACE_DIR/Makefile"
    sed -i "s/##APP_NAME##/\"${APP_NAME}\"/g" "$WORKSPACE_DIR/Makefile"
else
    echo "Makefile already exists in the destination, skipping copy."
fi


echo "Configuration des shells installée avec succès."

