#!/bin/bash

# Clé d'authentification GitHub
@ici github pat

# Dépôt à ajouter
VCS_URL="git@github.com:mus-inn/lth-v2.git"

# Variables à ajouter dans .env et .env.example
# ici open ai

# Forcer l'ajout ou la mise à jour des variables dans un fichier
update_env_file() {
    local file="$1"

    echo "Mise à jour ou ajout des variables dans $file..."
    if [ ! -f "$file" ]; then
        echo "Le fichier $file n'existe pas. Création..."
        touch "$file"
    fi

    # Utiliser awk pour ajouter ou remplacer les lignes dans le fichier
    awk -v key1="OPENAI_API_KEY" -v value1="$OPENAI_API_KEY" \
        -v key2="OPENAI_ORGANIZATION" -v value2="$OPENAI_ORGANIZATION" '
        BEGIN { key1_found=0; key2_found=0 }
        $0 ~ "^" key1 "=" { print key1 "=" value1; key1_found=1; next }
        $0 ~ "^" key2 "=" { print key2 "=" value2; key2_found=1; next }
        { print }
        END {
            if (!key1_found) print key1 "=" value1;
            if (!key2_found) print key2 "=" value2;
        }' "$file" > "${file}.tmp" && mv "${file}.tmp" "$file"

    echo "Mise à jour terminée pour $file."
}

# Vérifier si auth.json existe déjà
AUTH_FILE="auth.json"

if [ -f "$AUTH_FILE" ]; then
    echo "Le fichier auth.json existe déjà. Suppression..."
    rm -f "$AUTH_FILE"
fi

# Créer un fichier auth.json avec la nouvelle clé
echo "Création du fichier auth.json à la racine..."
cat > "$AUTH_FILE" <<EOL
{
    "github-oauth": {
        "github.com": "$GITHUB_PAT"
    }
}
EOL
echo "Fichier auth.json créé avec succès."

# Vérifier si composer.json existe
if [ ! -f "composer.json" ]; then
    echo "Erreur : Le fichier composer.json est introuvable dans le répertoire actuel."
    exit 1
fi

# Vérifier si le dépôt VCS est déjà présent dans composer.json
if jq -e ".repositories[] | select(.url == \"$VCS_URL\")" composer.json > /dev/null 2>&1; then
    echo "Le dépôt '$VCS_URL' est déjà présent dans composer.json."
else
    echo "Ajout du dépôt '$VCS_URL' dans composer.json..."
    jq ".repositories += [{\"type\": \"vcs\", \"url\": \"$VCS_URL\"}] |
        . + {\"minimum-stability\": \"dev\", \"prefer-stable\": true}" composer.json > composer.tmp && mv composer.tmp composer.json
    if [ $? -ne 0 ]; then
        echo "Erreur : L'ajout du dépôt dans composer.json a échoué."
        exit 1
    fi
    echo "Dépôt ajouté avec succès dans composer.json."
fi

# Installer le package LTH v2 avec Composer
echo "Installation du package musine/lth-v2 avec Composer..."
composer require musine/lth-v2
if [ $? -ne 0 ]; then
    echo "Erreur : L'installation du package musine/lth-v2 a échoué."
    exit 1
fi

# Publier les fichiers de configuration
echo "Publication des fichiers de configuration de LTH v2..."
php artisan vendor:publish --tag="lth-v2-config"
if [ $? -ne 0 ]; then
    echo "Erreur : La publication des fichiers de configuration a échoué."
    exit 1
fi

# Ajouter ou mettre à jour les variables dans .env et .env.example
update_env_file ".env"
update_env_file ".env.example"

# Vérification finale des mises à jour
echo "Vérification des variables ajoutées dans .env et .env.example..."
cat .env | grep -E "OPENAI_API_KEY|OPENAI_ORGANIZATION"
cat .env.example | grep -E "OPENAI_API_KEY|OPENAI_ORGANIZATION"

# Installation terminée
echo "Installation de LTH v2 terminée avec succès. Vous pouvez accéder à l'interface via l'URL : https://your-url.com/lth-v2"
exit 0
