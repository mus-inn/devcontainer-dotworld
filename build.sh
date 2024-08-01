#!/bin/bash

# Fonction pour transformer une chaîne en minuscule et la slugifier
slugify() {
    echo "$1" | tr '[:upper:]' '[:lower:]' | tr -s ' ' '-' | tr -cd '[:alnum:]-'
}

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Fonction pour afficher le header d'étape
print_step() {
    STEP_NUM=$1
    TOTAL_STEPS=7
    CURRENT_TIME=$(date +"%H:%M:%S")
    PROGRESS=$((STEP_NUM * 100 / TOTAL_STEPS))
    
    clear
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}Dotworld Build Docker${NC}"
    echo -e "${MAGENTA}🕒 Heure actuelle : ${CURRENT_TIME}${NC}"
    echo -e "${BLUE}🔄 Progression : ${PROGRESS}%  (${STEP_NUM}/${TOTAL_STEPS})${NC}${NC}"
    echo -e "${GREEN}📁 Work Directory: $(pwd)${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "\n\n"
}


run_with_script() {
    local command="$1"
    local input="$2"

    # Utiliser `script` pour exécuter la commande dans un environnement TTY
    script -q -c "$command" /dev/null <<< "$input"
}


# Fonction pour vérifier si l'utilisateur est connecté à Docker Hub
is_docker_logged_in() {
    # Vérification de la connexion initiale
    output=$(run_with_script "docker login" "")

    # Vérifier l'état de connexion en analysant la sortie
    if [[ "$output" == *"Login Succeeded"* ]]; then
       echo "ok"
    else
       echo "ko"
    fi    
}

# Fonction pour exécuter une commande et capturer les erreurs en temps réel
run_command() {
    COMMAND=$1
    echo -e "${BLUE}Exécution de : ${COMMAND}${NC}"
    bash -c "$COMMAND"
    EXIT_CODE=${PIPESTATUS[0]}
    if [ $EXIT_CODE -ne 0 ]; then
        echo -e "${RED}❌ Erreur lors de l'exécution de la commande :${NC}\n"
        echo -e "${YELLOW}Veuillez corriger les erreurs et réessayer.${NC}"
        exit 1
    else
        echo -e "${GREEN}✅ Commande exécutée avec succès.${NC}"
    fi
}

# Fonction pour obtenir les informations de l'image Docker sans jq
get_image_info() {
    IMAGE=$1
    INFO=$(docker inspect --format='{{json .}}' $IMAGE)

    # Extraire le nom de l'image (le tag complet)
    IMAGE_NAME=$(echo "$INFO" | sed -n 's/.*"RepoTags":\["\([^"]*\)".*/\1/p')

    # Extraire la taille de l'image
    IMAGE_SIZE=$(echo "$INFO" | sed -n 's/.*"Size":\([0-9]*\).*/\1/p')
    IMAGE_SIZE_MB=$(awk "BEGIN { printf \"%.2f\", $IMAGE_SIZE / (1024*1024) }")

    echo -e "${YELLOW}📋 Récapitulatif de l'image Docker${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}📛 Nom de l'image     : ${NC}${MAGENTA}${IMAGE_NAME:-Non défini}${NC}"
    echo -e "${GREEN}📏 Taille de l'image  : ${NC}${MAGENTA}${IMAGE_SIZE_MB:-Non défini} MB${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

# Chemin de base des images Docker
BASE_PATH="builds/docker"

# Sélection du mode de construction
print_step 1
echo -e "${BLUE}🔧 Sélectionnez le type de build :${NC}"
echo -e "1) Test en local"
echo -e "2) Push multi-arch sur Docker Hub"

read -p "Votre choix (1/2) : " BUILD_TYPE

# Etape 2: Sélection de l'image Docker
print_step 2
echo -e "${BLUE}🚀 Sélectionnez une image Docker à build :${NC}\n"
select IMAGE_NAME in $(ls $BASE_PATH); do
    if [ -n "$IMAGE_NAME" ]; then
        break
    else
        echo -e "\n${RED}Sélection non valide. Veuillez réessayer.${NC}\n"
    fi
done

# Etape 3: Création du nom et de l'adresse du repo
print_step 3
SLUG_IMAGE_NAME=$(slugify "$IMAGE_NAME")
REPO_NAME="chdotworld/dotworld"
DOCKERFILE_BASE=$BASE_PATH/$IMAGE_NAME
TAG_NAME="$REPO_NAME:$SLUG_IMAGE_NAME"

case $BUILD_TYPE in
    1)
        ARCHITECTURE=""
        ;;
    2)
        docker buildx create --name mybuilder --bootstrap --use
        ARCHITECTURE="linux/amd64,linux/arm64"
        ;;
    *)
        echo -e "${RED}Choix invalide.${NC}"
        exit 1
        ;;
esac

echo -e "${YELLOW}📦 Le repository Docker Hub sera : ${GREEN}$REPO_NAME${NC}"
echo -e "${YELLOW}🏷️  Le tag de l'image sera : ${GREEN}$TAG_NAME${NC}\n"

read -p "Confirmez-vous ces informations ? (O/n) : " CONFIRM_REPO

if [[ $CONFIRM_REPO =~ ^[Nn]$ ]]; then
    echo -e "\n${RED}Publication annulée.${NC}\n"
    exit 1
fi

# Etape 4: Connexion à Docker Hub (si nécessaire)
print_step 4
echo -e "${BLUE}🔑 Vérification de la connexion à Docker Hub...${NC}\n"
# Si l'utilisateur n'est pas connecté, demander les informations d'identification
if [[ $(is_docker_logged_in) == "ko" ]]; then
    echo -e "${BLUE}🔑 Connexion à Docker Hub...${NC}\n"
    read -p "🔑 Entrez votre identifiant Docker Hub : " DOCKER_USER
    read -sp "🔒 Entrez votre mot de passe Docker Hub : " DOCKER_PASS
    echo -e ""
    run_command "echo \"$DOCKER_PASS\" | docker login -u \"$DOCKER_USER\" --password-stdin"
else
    echo -e "${GREEN}✅ Déjà connecté à Docker Hub.${NC}\n"
fi

# Etape 5: Construction de l'image
print_step 5

if [ "$BUILD_TYPE" -eq 1 ]; then
    echo -e "${BLUE}🏗️  Construction de l'image en local...${NC}\n"
    run_command "docker build -t $TAG_NAME --no-cache $DOCKERFILE_BASE"
else
    echo -e "${BLUE}🏗️  Construction et push de l'image pour les architectures $ARCHITECTURE...${NC}\n"
    run_command "docker buildx build --push -t $TAG_NAME --no-cache --platform $ARCHITECTURE $DOCKERFILE_BASE"
fi

# Etape 6: Afficher les informations de l'image
print_step 6

if [ "$BUILD_TYPE" -eq 1 ]; then
    echo -e "${BLUE}🔍 Récapitulatif de l'image construite...${NC}\n"
    get_image_info $TAG_NAME
    read -p "Avez-vous bien pris connaissance des informations ci-dessus ? (O/n) : " CONFIRM_READ
    if [[ $CONFIRM_READ =~ ^[Nn]$ ]]; then
        echo -e "\n${RED}Veuillez consulter les informations et réessayer.${NC}\n"
        exit 1
    fi
else
    echo -e "${YELLOW}📋 Récapitulatif de l'image Docker${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}📛 Nom de l'image     : ${NC}${MAGENTA}${TAG_NAME:-Non défini}${NC}"
    echo -e "${GREEN}📏 Taille de l'image  : ${NC}${MAGENTA}Non disponible en mode multi-arch${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
    read -p "Avez-vous bien pris connaissance des informations ci-dessus ? (O/n) : " CONFIRM_READ
    if [[ $CONFIRM_READ =~ ^[Nn]$ ]]; then
        echo -e "\n${RED}Veuillez consulter les informations et réessayer.${NC}\n"
        exit 1
    fi
fi

# Etape finale: Confirmation de la publication
print_step 7
echo -e "${GREEN}🎉 L'image a été construite avec succès !${NC}\n"
