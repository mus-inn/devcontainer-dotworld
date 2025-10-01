#!/bin/bash

cmd="install"
description="Initialiser le projet en lançant toutes les commandes."
author="Gtko"

source $UTILS_DIR/functions.sh

# create .env
print_message "Créer le .env a partir du .env.example" "📦"
cp $WORKSPACE_DIR/.env.example $WORKSPACE_DIR/.env

# Exécuter les commandes avec des barres de progression
print_message "Installation des dépendances Composer" "📦"
composer install

# Install Laravel Octane with FrankenPHP
print_message "Installation de Laravel Octane avec FrankenPHP" "🚀"
php artisan octane:install --server=frankenphp

print_message "Migration de la base de données et initialisation des données" "🗃️"
php artisan migrate:fresh --seed

print_message "Installation des dépendances NPM" "📦"
npm install

complete "Initialisation terminée !"

