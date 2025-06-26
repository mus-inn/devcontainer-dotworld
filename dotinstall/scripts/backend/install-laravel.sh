#!/bin/bash

echo "Installation d'un nouveau projet Laravel nommé 'my_project'..."

# Vérifier si Composer est installé
if ! command -v composer &> /dev/null; then
    echo "Erreur : Composer n'est pas installé. Veuillez l'installer et réessayer."
    exit 1
fi

# Créer un nouveau projet Laravel dans un sous-dossier temporaire
composer create-project --prefer-dist laravel/laravel my_project

# Vérifier si le dossier a été créé avec succès
if [ -d "my_project" ]; then
    echo "Projet Laravel 'my_project' créé avec succès."
else
    echo "Erreur : Impossible de créer le projet Laravel."
    exit 1
fi

# Déplacer tous les fichiers du sous-dossier 'my_project' à la racine
echo "Déplacement des fichiers à la racine..."
mv my_project/* my_project/.* . 2>/dev/null

# Supprimer le dossier temporaire 'my_project'
echo "Suppression du dossier temporaire 'my_project'..."
rm -rf my_project

# Vérifier si les fichiers ont bien été déplacés
if [ ! -d "my_project" ] && [ -f "artisan" ]; then
    echo "Le projet Laravel a été déplacé à la racine et le dossier 'my_project' supprimé avec succès."
else
    echo "Erreur : Problème lors du déplacement ou de la suppression du dossier 'my_project'."
    exit 1
fi

echo "Installation de Laravel terminée avec succès."
