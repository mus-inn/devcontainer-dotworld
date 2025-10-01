#!/bin/bash

# Titre et description du script
cmd="artisan"
description="lancer l'artisan du projet Laravel courant"
author="Thibaud WILLM <thibaud.willm@dotworld.ch"

source $UTILS_DIR/functions.sh

#si il n'y a pas d'argument en demander un avec gum
if [ $# -eq 0 ]; then
    php $WORKSPACE_DIR/artisan
    cmd_artisan=$(gum input --placeholder "que veux tu lancer sur artisan ?")
    php $WORKSPACE_DIR/artisan $cmd_artisan
else
    # Lancer l'artisan
    php $WORKSPACE_DIR/artisan $*
fi


