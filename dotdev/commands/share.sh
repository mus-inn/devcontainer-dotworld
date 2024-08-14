#!/bin/bash

# Titre et description du script
cmd="share"
description="Permet d'exposer l'application sur internet."
author="Gtko"

source $UTILS_DIR/functions.sh

# Chemin vers le fichier de sauvegarde
SAVE_FILE="$HOME/state-expose.txt"

# Si le fichier existe et que l'argument force n'est pas passé, utiliser le nom enregistré
if [[ -f "$SAVE_FILE" && "$1" != "force" ]]; then
    random_name=$(cat "$SAVE_FILE")
else
    # Définir les noms communs masculins et féminins avec beaucoup plus de choix (200+)
    nouns_masculine=("chien" "chat" "lion" "tigre" "soleil" "montagne" "vent" "rocher" "arbre" "ocean"
                     "cheval" "vautour" "requin" "panda" "elephant" "renard" "loup" "phenix" "corbeau" "ours"
                     "dragon" "faucon" "aigle" "serpent" "bison" "hibou" "coq" "paon" "lynx" "cerf"
                     "camion" "ordinateur" "livre" "bateau" "avion" "table" "stylo" "miroir" "telephone" "brouillard"
                     "nuage" "champ" "banc" "tigre" "dragon" "tigre" "requin" "corbeau" "souvenir" "aigle" "sanglier")

    nouns_feminine=("fleur" "lune" "etoile" "riviere" "mer" "foret" "glace" "brise" "pluie" "montagne"
                    "vague" "tulipe" "rose" "loutre" "marmotte" "gazelle" "souris" "panthere" "hirondelle" "araignee"
                    "biche" "chouette" "baleine" "dauphin" "medaille" "perle" "galaxie" "tortue" "libellule"
                    "maison" "chaise" "porte" "fenetre" "lumiere" "ombre" "route" "voiture" "ville" "fontaine"
                    "cle" "chanson" "voix" "musique" "parole" "promesse" "pensee" "idee" "cascade")

    # Définir les adjectifs masculins et féminins avec beaucoup plus de choix (200+)
    adjectives_masculine=("grand" "petit" "fou" "sage" "rapide" "lent" "fort" "sombre" "clair" "heureux"
                          "courageux" "sauvage" "mysterieux" "loyal" "vaillant" "ruse" "vif" "robuste" "feroce" "doux"
                          "calme" "energique" "silencieux" "intelligent" "habile" "puissant" "hardy" "flamboyant" "brillant"
                          "lourd" "leger" "bruyant" "silencieux" "chaud" "froid" "clair" "obscur" "dense" "fin"
                          "vieux" "jeune" "neuf" "vif" "ancien" "nouveau" "beau" "laid" "joli" "vilain")

    adjectives_feminine=("grande" "petite" "folle" "sage" "rapide" "lente" "forte" "sombre" "claire" "heureuse"
                         "courageuse" "sauvage" "mysterieuse" "loyale" "vaillante" "rusee" "vive" "robuste" "feroce" "douce"
                         "calme" "energique" "silencieuse" "intelligente" "habile" "puissante" "hardie" "flamboyante" "brillante"
                         "lourde" "legere" "bruyante" "silencieuse" "chaude" "froide" "claire" "obscure" "dense" "fine"
                         "vieille" "jeune" "neuve" "vive" "ancienne" "nouvelle" "belle" "laide" "jolie" "vilain")

    # Définir les superlatifs (optionnels)
    superlatives=("tres" "super" "ultra" "hyper" "beaucoup" "mega" "archi" "extra" "" "" "") # Ajout de chaînes vides pour avoir parfois un superlatif absent

    # Générer un type aléatoire pour décider si le nom sera masculin ou féminin
    if (( RANDOM % 2 )); then
        # Sélectionner un nom et un adjectif masculins
        noun=${nouns_masculine[$RANDOM % ${#nouns_masculine[@]}]}
        adjective=${adjectives_masculine[$RANDOM % ${#adjectives_masculine[@]}]}
    else
        # Sélectionner un nom et un adjectif féminins
        noun=${nouns_feminine[$RANDOM % ${#nouns_feminine[@]}]}
        adjective=${adjectives_feminine[$RANDOM % ${#adjectives_feminine[@]}]}
    fi

    # Sélectionner un superlatif (ou non)
    superlative=${superlatives[$RANDOM % ${#superlatives[@]}]}

    if [[ -n "$superlative" ]]; then
        # Si un superlatif est présent, ajoutez un tiret à la fin
        superlative="$superlative-"
    fi


    random_name="${noun}-${superlative}${adjective}"
    # Sauvegarder le nom généré dans le fichier
    echo "$random_name" > "$SAVE_FILE"
fi

# Créer une variable d'environnement avec le nom généré ou récupéré
export RANDOM_ENV_NAME="$random_name"


# Définir l'URL par défaut ou prendre celle fournie en argument
share_url=${1:-"http://127.0.0.1:80"}

# Exécuter la commande expose avec le sous-domaine généré

bin="$DOTDEV_DIR/bin/expose"
chmod +x "$bin"

$bin share "$share_url" \
    --server="https://dotshare.dev" \
    --server-host="dotshare.dev" \
    --server-port="443" \
    --auth="admin:dotworld-test-admin" \
    --subdomain="${RANDOM_ENV_NAME}"
