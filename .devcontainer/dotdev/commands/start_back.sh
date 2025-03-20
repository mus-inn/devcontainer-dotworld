#!/bin/bash

###############################################################################
#                                                                             #
# Script pour lancer le serve et le share en une seule commande.              #
#                                                                             #
# Cela permet d'ajouter la commande suivante dans le makefile :               #
#   start-backend:                                                            #
#     @docker exec -it $(container) bash -ic 'dotdev start_back'              #
#                                                                             #
###############################################################################

# Fonction pour arrêter les processus enfants
function cleanup {
    echo "Arrêt des processus..."
    kill $serve_pid
    wait $serve_pid
    echo "Tous les processus ont été arrêtés."
}

# Capturer le signal Ctrl+C pour nettoyer
trap cleanup SIGINT

# Lancer serve.sh en arrière-plan avec bash
nohup bash $CUSTOM_COMMANDS_DIR/serve.sh &> /dev/null &
serve_pid=$!

# Lancer share.sh en arrière-plan avec bash
bash $COMMANDS_DIR/share.sh

# Attendre que les deux processus se terminent
wait $serve_pid