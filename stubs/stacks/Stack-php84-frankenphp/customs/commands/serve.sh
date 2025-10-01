#!/bin/bash

# Titre et description du script
cmd="Serve"
description="Serveur Laravel Octane avec FrankenPHP !"
author="Thibaud WILLM"

source $UTILS_DIR/functions.sh

# Exécuter les commandes avec des barres de progression
print_message "Lancement du serveur Laravel Octane avec FrankenPHP" "🚀"
php artisan octane:start --server=frankenphp --host=0.0.0.0 --port=80

