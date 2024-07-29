#!/bin/bash

# Titre et description du script
cmd="Serve"
description="Serveur laravel artisan !"
author="Gtko"

source $UTILS_DIR/functions.sh

# Exécuter les commandes avec des barres de progression
print_message "Lancement du serveur de dev" "📦"
php artisan serve
