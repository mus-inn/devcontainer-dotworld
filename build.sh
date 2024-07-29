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
    TOTAL_STEPS=8
    CURRENT_TIME=$(date +"%H:%M:%S")
    PROGRESS=$((STEP_NUM * 100 / TOTAL_STEPS))
    
    clear
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}Dotworld Build Docker${NC}"
    echo -e "${MAGENTA}🕒 Heure actuelle : ${CURRENT_TIME}${NC}"
    echo -e "${BLUE}🔄 Progression : ${PROGRESS}%  (${STEP_NUM}/${TOTAL_STEPS})${NC}${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "\n\n"
}

# Fonction pour vérifier si l'utilisateur est connecté à Docker Hub
is_docker_logged_in() {
    LOGIN_OUTPUT=$(docker login 2>&1)
    echo "$LOGIN_OUTPUT" | grep -q "Login Succeeded"
    return $?
}

# Fonction pour exécuter une commande et capturer les erreurs en temps réel
run_command() {
    COMMAND=$1
    echo -e "${BLUE}Exécution de : ${COMMAND}${NC}"
    bash -c "$COMMAND" 2>&1 | tee /dev/tty
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
    INFO=$(docker inspect $IMAGE)
    IMAGE_NAME=$(echo "$INFO" | grep -m 1 "\"RepoTags\"" | awk -F '[\\[\\]" ]+' '{print $5}')
    IMAGE_SIZE=$(echo "$INFO" | grep -m 1 "\"Size\"" | awk -F '[:, ]+' '{print $3}')
    IMAGE_SIZE_MB=$(echo "scale=2; $IMAGE_SIZE / (1024*1024)" | bc)
    BASE_IMAGE=$(echo "$INFO" | grep -m 1 "\"Parent\"" | awk -F '[\\[\\]" ]+' '{print $5}')

    echo -e "${YELLOW}📋 Récapitulatif de l'image Docker${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}📛 Nom de l'image     : ${NC}${MAGENTA}$IMAGE_NAME${NC}"
    echo -e "${GREEN}📏 Taille de l'image  : ${NC}${MAGENTA}$IMAGE_SIZE_MB MB${NC}"
    echo -e "${GREEN}🛠️  Image de base      : ${NC}${MAGENTA}$BASE_IMAGE${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

# Chemin de base des images Docker
BASE_PATH="builds/docker"

# Etape 1: Sélection de l'image Docker
print_step 1
echo -e "${BLUE}🚀 Sélectionnez une image Docker à build :${NC}\n"
select IMAGE_NAME in $(ls $BASE_PATH); do
    if [ -n "$IMAGE_NAME" ]; then
        break
    else
        echo -e "\n${RED}Sélection non valide. Veuillez réessayer.${NC}\n"
    fi
done

# Etape 2: Vérification de la connexion à Docker Hub
print_step 2
if is_docker_logged_in; then
    echo -e "${GREEN}✅ Vous êtes déjà connecté à Docker Hub.${NC}\n"
else
    read -p "🔑 Entrez votre identifiant Docker Hub : " DOCKER_USER
    read -sp "🔒 Entrez votre mot de passe Docker Hub : " DOCKER_PASS
    echo
    run_command "echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin"
fi

# Etape 3: Création du nom et de l'adresse du repo
print_step 3
SLUG_IMAGE_NAME=$(slugify "$IMAGE_NAME")
REPO_NAME="chdotworld/dotworld"
TAG_NAME="$REPO_NAME:$SLUG_IMAGE_NAME-alpine"

echo -e "${YELLOW}📦 Le repository Docker Hub sera : ${GREEN}$REPO_NAME${NC}"
echo -e "${YELLOW}🏷️  Le tag de l'image sera : ${GREEN}$TAG_NAME${NC}\n"

read -p "Confirmez-vous ces informations ? (O/n) : " CONFIRM_REPO

if [[ $CONFIRM_REPO =~ ^[Nn]$ ]]; then
    echo -e "\n${RED}Publication annulée.${NC}\n"
    exit 1
fi

# Etape 4: Construction de l'image
print_step 4
echo -e "${BLUE}🏗️  Construction de l'image...${NC}\n"
run_command "docker build -t $TAG_NAME $BASE_PATH/$IMAGE_NAME --no-cache"

# Etape 5: Afficher les informations de l'image
print_step 5
echo -e "${BLUE}🔍 Récapitulatif de l'image construite...${NC}\n"
get_image_info $TAG_NAME

# Demande de confirmation pour publier l'image
read -p "Voulez-vous publier cette image sur Docker Hub ? (O/n) : " CONFIRM_PUSH

if [[ $CONFIRM_PUSH =~ ^[Nn]$ ]]; then
    echo -e "\n${RED}Publication annulée.${NC}\n"
    exit 0
fi

# Etape 6: Connexion à Docker Hub (si nécessaire)
print_step 6
if ! is_docker_logged_in; then
    echo -e "${BLUE}🔑 Connexion à Docker Hub...${NC}\n"
    run_command "echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin"
fi

# Etape 7: Publication de l'image
print_step 7
echo -e "${BLUE}📤 Publication de l'image...${NC}\n"
run_command "docker push $TAG_NAME"

# Etape finale: Confirmation de la publication
print_step 8
echo -e "${GREEN}🎉 L'image ${TAG_NAME} a été publiée sur Docker Hub.${NC}\n"
