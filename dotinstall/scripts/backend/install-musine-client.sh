#!/bin/bash

# Clé d'authentification GitHub
#ici github pat

# Vérifier si Composer est installé
if ! command -v composer &> /dev/null; then
    echo "Erreur : Composer n'est pas installé. Veuillez installer Composer et réessayer."
    exit 1
fi

# Vérifier si PHP est installé
if ! command -v php &> /dev/null; then
    echo "Erreur : PHP n'est pas installé. Veuillez installer PHP et réessayer."
    exit 1
fi

# Créer un fichier auth.json à la racine
echo "Création du fichier auth.json à la racine..."
cat > auth.json <<EOL
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

# Modifier le fichier composer.json pour ajouter le dépôt et les réglages de stabilité
echo "Mise à jour de composer.json..."
jq '.repositories += [{"type": "vcs", "url": "https://github.com/mus-inn/musineClient-next"}] |
    . + {"minimum-stability": "dev", "prefer-stable": true}' composer.json > composer.tmp && mv composer.tmp composer.json
if [ $? -ne 0 ]; then
    echo "Erreur : La mise à jour de composer.json a échoué."
    exit 1
fi
echo "Fichier composer.json mis à jour avec succès."

# Installer le package musine-client-api avec Composer
echo "Installation du package musine/musine-client-api avec Composer..."
composer require musine/musine-client-api
if [ $? -ne 0 ]; then
    echo "Erreur : L'installation du package musine/musine-client-api a échoué."
    exit 1
fi

# Copier les fichiers depuis dotinstall/files/backend/Actions/Payment vers app/Actions/Payment
SOURCE_ACTIONS="dotinstall/files/backend/Actions/Payment"
DEST_ACTIONS="app/Actions/Payment"

echo "Copie des fichiers depuis '$SOURCE_ACTIONS' vers '$DEST_ACTIONS'..."
if [ -d "$SOURCE_ACTIONS" ]; then
    mkdir -p "$DEST_ACTIONS"
    cp -r "$SOURCE_ACTIONS/"* "$DEST_ACTIONS/"
    echo "Fichiers copiés avec succès dans '$DEST_ACTIONS'."
else
    echo "Erreur : Le répertoire source '$SOURCE_ACTIONS' est introuvable."
    exit 1
fi

# Remplacer AppServiceProvider par celui de dotinstall/files/backend/Providers
SOURCE_PROVIDER="dotinstall/files/backend/Providers/AppServiceProvider.php"
DEST_PROVIDER="app/Providers/AppServiceProvider.php"

echo "Remplacement de '$DEST_PROVIDER' par '$SOURCE_PROVIDER'..."
if [ -f "$SOURCE_PROVIDER" ]; then
    cp "$SOURCE_PROVIDER" "$DEST_PROVIDER"
    echo "AppServiceProvider remplacé avec succès."
else
    echo "Erreur : Le fichier source '$SOURCE_PROVIDER' est introuvable."
    exit 1
fi

# Publier les fichiers de configuration du package
echo "Publication des fichiers de configuration du package musine-client-api..."
php artisan vendor:publish --provider="Musine\MusineClientApi\MusineClientServiceProvider"
if [ $? -ne 0 ]; then
    echo "Erreur : La publication des fichiers de configuration a échoué."
    exit 1
fi
echo "Fichiers de configuration publiés avec succès."

# Installation terminée
echo "Installation du client Musine terminée avec succès."
exit 0
