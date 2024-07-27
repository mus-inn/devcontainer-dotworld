#!/bin/bash

# Titre et description du script
cmd="demo"
description="Ce script montre une demonstration."
author="Gtko"

source $UTILS_DIR/functions.sh

# Exécuter les commandes avec des barres de progression
print_message "Message pour le lancement de la demo" "📦"
run_with_spinner "📦 Installation simulé par un sleep" "sleep 5"
run_with_spinner "📦 Installation 2 simulé par un sleep de 3s" "sleep 3"

complete "Installation terminée avec succès!"
