#!/bin/bash

# Installer gum si non présent
if ! command -v gum &> /dev/null
then
    echo "gum n'est pas installé. Veuillez l'installer et réessayer."
    exit 1
fi

# Vérifier si le répertoire existe
if [ ! -d "$COMMANDS_DIR" ]; then
    gum style --foreground 1 "Le répertoire $COMMANDS_DIR n'existe pas."
    exit 1
fi

# On envoie tous ce qui a normalement dans le custom dans le repertoire commands

cp -r "$CUSTOM_COMMANDS_DIR"/* "$COMMANDS_DIR"

# Gestion de signal pour quitter proprement
trap "gum style --foreground 2 'Au revoir!' ; exit" SIGINT

# Fonction d'aide
function help {
    if [ "$#" -eq 1 ]; then
        cat << EOF

Usage: dotdev [OPTIONS] [ARGUMENTS]

🚀 DotDev - Outil pour les développeurs de Dotworld

🔧 Fonctionnalités :
   Exécutez les scripts Bash en mode interactif que vos collègues ou vous-même avez produits pour vous simplifier la vie.

🌟 Options :
   help            Affiche ce message d'aide.
   -v, --version   Affiche la version du script.

📜 Commandes disponibles :
EOF

max_cmd_length=0
for script in "$COMMANDS_DIR"/*.sh; do
    cmd=$(grep -m 1 '^cmd=' "$script" | cut -d '=' -f 2 | tr -d '"')
    if [ -z "$cmd" ]; then
        cmd=$(basename "$script" .sh)
    fi
    if (( ${#cmd} > max_cmd_length )); then
        max_cmd_length=${#cmd}
    fi
done

# Afficher les commandes et leurs descriptions avec un alignement correct
for script in "$COMMANDS_DIR"/*.sh; do
    cmd=$(grep -m 1 '^cmd=' "$script" | cut -d '=' -f 2 | tr -d '"')
    description=$(grep -m 1 '^description=' "$script" | cut -d '=' -f 2 | tr -d '"')

    # Si le titre est vide, utiliser le nom du fichier sans extension
    if [ -z "$cmd" ]; then
        cmd=$(basename "$script" .sh)
    fi

    # Afficher les commandes et leurs descriptions avec un alignement correct
    printf "   %-${max_cmd_length}s  %s\n" "$cmd" "$description"
done

        cat << EOF

📋 Exemples :
   - dotdev help               Affiche ce message d'aide.
   - dotdev -v                 Affiche la version de DotDev.
   - dotdev [commande]         Lance la commande directement.
   - dotdev [commande] help    Affiche l'aide spécifique pour une commande.

EOF
    else
        script_name="$1"
        script_path="${COMMANDS_DIR}/${script_name}.sh"

        if [ -f "$script_path" ]; then
            echo "Aide pour la commande '$script_name':"
            grep '^help=' "$script_path" | cut -d '=' -f 2 | tr -d '"'
        else
            echo "La commande spécifiée n'existe pas."
        fi
    fi
}

# Fonction pour afficher la version
function version {
    echo "Version 1.0"
}


# Fonction pour afficher le menu et gérer les choix de l'utilisateur
function show_menu() {

    local options=()
    local files=()

    local i=1

    for script in "$COMMANDS_DIR"/*.sh; do
        # Extraire le titre et la description
        cmd=$(grep -m 1 '^cmd=' "$script" | cut -d '=' -f 2 | tr -d '"')
        description="- $(grep -m 1 '^description=' "$script" | cut -d '=' -f 2 | tr -d '"')"

        # Si le titre est vide, utiliser le nom du fichier sans extension et mettre la description à vide
        if [ -z "$cmd" ]; then
            cmd=$(basename "$script" .sh)
            description=""
        fi

        # Ajouter les options et les titres aux tableaux
        options+=("$i) $cmd $description")
        files+=("$(basename "$script")")

        # Incrémenter le compteur
        ((i++))
    done

    options+=("$i) Quitter")
    choice=$(gum choose --header "Tu veux faire quoi ?" "${options[@]}")
    choice=$(echo "$choice" | grep -o '^[0-9]\+')
    choice=$(($choice - 1))
    files+=("Quitter")


    echo "${files[$choice]}"

}



# Fonction pour exécuter le script choisi
function execute_script() {
    local script="$COMMANDS_DIR/$1"
    if [ -f "$script" ]; then
          clear
          cmd=$(grep -m 1 '^cmd=' "$script" | cut -d '=' -f 2 | tr -d '"')
          description=$(grep -m 1 '^description=' "$script" | cut -d '=' -f 2 | tr -d '"')
          author=$(grep -m 1 '^author=' "$script" | cut -d '=' -f 2 | tr -d '"')

          # Définir les valeurs par défaut si elles sont vides
          if [ -z "$cmd" ]; then
              cmd=$(basename "$script" .sh)
          fi

          if [ -z "$author" ]; then
              author="Dotworld"
          fi

          echo -e "${COLOR_GREEN}"
          echo -e "Run script"
          figlet -f /usr/share/figlet/fonts/'ANSI Shadow.flf' -w 200 "$cmd"
          echo -e "By $author"
          echo -e "${COLOR_RESET}"

          if [ -n "$description" ]; then
              echo -e "\033[1;34m $description \033[0m"
          fi

          echo -e ""
          echo -e ""
          bash "$script"
    else
        gum style --foreground 1 "La commande spécifié n'existe pas."
    fi
}

# Définir la couleur (vert dans cet exemple)
COLOR_GREEN='\033[0;32m'
COLOR_RESET='\033[0m'

# Vérifier les arguments en ligne de commande
if [ "$#" -gt 0 ]; then
    case $1 in
        help)
            help "$2"
            exit 0
            ;;
        -v|--version)
            version
            exit 0
            ;;
        -f|--file)
            FILE=$2
            echo "Fichier spécifié : $FILE"
            shift # passer à l'argument suivant
            ;;
        -n|--name)
            NAME=$2
            echo "Nom spécifié : $NAME"
            shift # passer à l'argument suivant
            ;;
        *)


                script_name="$1.sh"
                shift
                execute_script "$script_name" "$@"
                exit $?

            ;;
    esac
fi


# Boucle principale pour afficher le menu et lire le choix de l'utilisateur
while true; do

    clear

    echo -e "${COLOR_GREEN}"
    echo -e "Welcome to"
    figlet -f /usr/share/figlet/fonts/'ANSI Shadow.flf' -w 200 "DotDev"
    echo -e "By Dotworld"
    echo -e "${COLOR_RESET}"

    user_choice=$(show_menu)

    gum style --foreground 2  "Tu as choisis l'option  : $user_choice"


    if [ $? -ne 0 ]; then
        clear
        gum style --foreground 2 "Au revoir!"
        sleep 1
        clear
        break
    fi
    if [[ "$user_choice" == "Quitter" ]]; then
        clear
        gum style --foreground 2 "Au revoir!"
        sleep 1
        clear
        break
    else
        execute_script "$user_choice"
    fi
done
