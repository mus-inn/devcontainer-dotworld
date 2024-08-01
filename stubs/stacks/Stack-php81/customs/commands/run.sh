#!/bin/bash


# Titre et description du script
cmd="run"
description="Lancement de la compilation des assets en mode developpeur."
author="Gtko"

source $UTILS_DIR/functions.sh

cd $WORKSPACE_DIR
print_message "Lancement de la compilation du frontend" "⚙️" $COLOR_GREEN
npm run watch

