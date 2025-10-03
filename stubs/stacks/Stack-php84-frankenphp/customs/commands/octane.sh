#!/bin/bash

# Titre et description du script
cmd="octane"
description="Lancer Laravel Octane avec FrankenPHP (mode watch pour auto-reload)"
author="Thibaud WILLM"

source $UTILS_DIR/functions.sh

# Vérifier si on veut le mode watch
if [ "$1" == "--watch" ] || [ "$1" == "-w" ]; then
    print_message "Lancement du serveur Laravel Octane avec FrankenPHP en mode watch" "🚀"
    php artisan octane:start --server=frankenphp --host=0.0.0.0 --port=80 --watch
else
    print_message "Lancement du serveur Laravel Octane avec FrankenPHP" "🚀"
    php artisan octane:start --server=frankenphp --host=0.0.0.0 --port=80
fi

