
# DotInstall 🚀

Bienvenue chez Dotworld, développeur superstar! 🌟 Voici **DotInstall**, l'outil incontournable pour gérer et installer vos environnements de développement en toute simplicité.

## En quoi consiste DotInstall ? 🤔

DotInstall vous permet de :

- **Compiler de nouvelles images Docker** 🐳
- **Construire des stacks de devcontainer prêtes à l'emploi** 🛠️
- **Mettre à jour Dotdev**, le cœur de votre environnement de développement, qui configure tout dès le démarrage et vous offre une commande magique pour interagir avec vos environnements ✨

## Comment utiliser Dotinstall.sh 🛠️

### Prérequis ✅

Avant de commencer, assurez-vous d'avoir installé `wget` ou `curl` sur votre machine. Placez-vous ensuite dans le codespace de votre projet ou dans votre dépôt git local.

### Installation 💻

1. **Téléchargez la dernière version de `dotinstall.sh` :**

   - Avec `wget` :

     ```bash
     wget https://github.com/mus-inn/devcontainer-dotworld/releases/latest/download/dotinstall.sh
     ```

   - Ou avec `curl` :

     ```bash
     curl -L -o dotinstall.sh https://github.com/mus-inn/devcontainer-dotworld/releases/latest/download/dotinstall.sh
     ```

2. **Exécutez le script téléchargé :**

   ```bash
   bash dotinstall.sh
   ```

3. **Suivez les instructions à l'écran.** Le formulaire est interactif et vous guidera tout au long du processus 📝.

### Découvrez Dotinstall en action :
Bienvenue dans notre série de vidéos expliquant le projet devcontainer Dotworld ! 🎥



[<img src="https://cdn.loom.com/sessions/thumbnails/fff183d5ca584c81bfe606492c3554bb-5e75055040f07598-full-play.gif" width="50%">](https://www.loom.com/embed/fff183d5ca584c81bfe606492c3554bb?sid=7077acb9-0b24-401f-bfd9-b4d4d173413c)

## Structure du Projet

Le projet est organisé en trois dossiers principaux :

1. **docker-build** : Contient les images Docker à créer pour nos conteneurs de développement.
2. **.dev** : Centralise les commandes et automatisations des conteneurs de développement, avec des commandes par défaut et des utilitaires.
3. **stacks** : Représente les différentes stacks installables, telles que "starter" et "PHP 8.1, Next.js".

## Outils Disponibles

1. **dotInstall** : Démarrez un environnement de développement, compilez des images, et mettez à jour les outils nécessaires.
2. **build docker dotworld** : Compilez des images Docker personnalisées à partir du dépôt devcontainer dotworld, en adaptant les paquets et technologies.

## Utilisation des Outils

- Utilisez **dotInstall** pour créer un nouvel espace de développement en sélectionnant une stack et en démarrant l'environnement.
- Avec **build docker dotworld**, compilez des images adaptées à vos besoins spécifiques, comme passer de PHP 8.1 à PHP 8.2.

## Compilation et Publication

- Le **build docker dotworld** peut être effectué localement pour des tests ou pour une publication sur Docker Hub, prenant en charge les architectures x86 et ARM64.

### Création ou Mise à Jour d'un Devcontainer avec Codespace

[<img src="https://cdn.loom.com/sessions/thumbnails/3774cc5679db427bb63967fe31a5be82-8ba52219ee1f6dd0-full-play.gif" width="50%">](https://www.loom.com/embed/3774cc5679db427bb63967fe31a5be82?sid=08cc0d25-300d-4d34-acda-a4263c5f3ab9)

Pour installer un devcontainer sur un dépôt avec CodeSpace, suivez ces étapes :

1. Allez dans le dépôt souhaité, cliquez sur "Code", puis sélectionnez "CodeSpace".
2. Une fois que le conteneur de base a démarré, ouvrez le README du devcontainer pour obtenir les commandes nécessaires.
3. Utilisez `curl` ou `wget` pour télécharger les fichiers requis dans le terminal du CodeSpace.
4. Téléchargez la dernière version de `dotinstall` et exécutez-la pour installer l'environnement de développement.
5. Configurez le devcontainer selon la technologie, par exemple avec la stack Next.js.
6. Redémarrez le CodeSpace avec l'icône de rechargement ou la commande `Ctrl+P`, puis `rebuild`.
7. Vous êtes prêt à travailler dans votre nouvel environnement de développement !

Suivez les instructions pour ouvrir les ports nécessaires et saisissez le mot de passe demandé pour démarrer votre session. Profitez de votre nouvel environnement de développement avec CodeSpace ! 🌐

### Création ou Mise à Jour d'un Devcontainer Local

[<img src="https://cdn.loom.com/sessions/thumbnails/ecc50557a21e4d80b8a5e5754743ebe2-5d775c2f127e1951-full-play.gif" width="50%">](https://www.loom.com/embed/ecc50557a21e4d80b8a5e5754743ebe2?sid=b0edbc9e-0eaa-43b2-9c65-daa7ea22746d)

Pour installer le DevContainer localement, procédez comme suit :

1. Assurez-vous d'avoir Docker installé sur votre machine.
2. Clonez le projet dans le répertoire souhaité avec `git clone`.
3. Accédez au répertoire du projet et téléchargez Dotinstall avec `curl` ou `wget`.
4. Exécutez `bash dotinstall` pour télécharger et installer le DevContainer.
5. Une fois l'installation terminée, vous verrez le .devcontainer dans le répertoire.
6. Sortez du répertoire avec `cd ..`.
7. Lancez le DevContainer avec `devcontainer up --workspace-folder Test-World-Frontend`.
8. Utilisez Visual Studio Code pour accéder au projet dans le DevContainer.

## Présentation de Dotdev

[<img src="https://cdn.loom.com/sessions/thumbnails/1d83a49fd6fa4000bbda2806f9dce7a7-d9ad3c1f1ef61700-full-play.gif" width="50%">](https://www.loom.com/embed/1d83a49fd6fa4000bbda2806f9dce7a7?sid=32410d33-9cae-4c72-819d-8b3efa4f7e12)

Dotdev fournit un terminal avec un en-tête mis à jour à chaque réinitialisation. Personnalisez le message de bienvenue en modifiant le fichier "welcome" dans le répertoire "custom".

- **Le fichier "install"** exécute des commandes au démarrage, idéal pour préparer l'environnement (par ex. installation de dépendances).
- **Les "alias"** permettent de créer des raccourcis dans le terminal.
- **Les "commandes"** permettent de définir des actions personnalisées pour votre projet.

Dotdev vous permet de mettre à jour le conteneur de développement, de changer l'environnement, et de gérer les images Docker. Utilisez `dotdev` pour simplifier vos tâches courantes sans mémoriser une tonne de commandes.

ℹ️ **tip:** dotdev se lance depuis le container Docker, il faut donc d'abord executer `make bash` depuis la racine du projet pour aller dans le container.

### Créez de Nouvelles Commandes pour Vous et vos Collègues :

[<img src="https://cdn.loom.com/sessions/thumbnails/557393061bf14e7b90b5e74653f894fb-b8b449aa1d74c793-full-play.gif" width="50%">](https://www.loom.com/embed/557393061bf14e7b90b5e74653f894fb?sid=d7e56d1e-8491-4af7-8794-8acb4d762aee)

### Créer ou Modifier une Stack Existante

[<img src="https://cdn.loom.com/sessions/thumbnails/f17c549d79a0477dbfaa1e6f6dddae4b-e6c512c631efd0fc-full-play.gif" width="50%">](https://www.loom.com/embed/f17c549d79a0477dbfaa1e6f6dddae4b?sid=2a4e17d7-dd06-48db-908c-1da9000e22c5)

[<img src="https://cdn.loom.com/sessions/thumbnails/73777a437bb041aea2d4d2e85bbe1058-0ac757b63040f2ab-full-play.gif" width="50%">](https://www.loom.com/embed/73777a437bb041aea2d4d2e85bbe1058?sid=163e7356-17e6-421b-8c19-1db927d7bf53)

#### Utiliser le depot local pour le developpement de votre Stack
💡 If you want to use local devcontainer-dotworld repository, please add the following code to your .bashrc/.zshrc to set the vars
```
    export DEVCONTAINER_USE_LOCAL_REPOSITORY=true 
    export DEVCONTAINER_LOCAL_REPOSITORY_FULLPATH=/path/to/devcontainer-dotworld # Change this to your local repository path
```
This mode will use the local repository instead of the remote one.


## Comment start mon devcontainer
Se mettre dans le repertoire et lancer cette commande
```
devcontainer up --workspace-folder .
```


## Comment exposer le port de votre application en public sur Codespaces

## Exposer son application

Pour exposer votre application, rien de plus simple :

```bash
dotdev share
```

ou bien :

```bash
dotdev share http://localhost:8000
```

Par défaut, le partage se fera sur l'hôte `127.0.0.1:80`.  
Si le sous-domaine existe déjà, considérez-vous chanceux avec une probabilité de 1 sur plus de 10 000.  
Dans ce cas, vous pouvez forcer la création d'un nouveau sous-domaine en ajoutant l'option `--force` :

```bash
dotdev share http://localhost:8000 --force
```

## J’aimerais Apporter ma Contribution ou J'ai Repéré un Bug 🔍

[<img src="https://cdn.loom.com/sessions/thumbnails/4ec0cb3ecbb04dca9f5acd1c1227f38d-3ed38017cc4fe119-full-play.gif" width="50%">](https://www.loom.com/embed/4ec0cb3ecbb04dca9f5acd1c1227f38d?sid=a8116445-2c91-4402-a35c-4099fcf36e96)

## Support et Contribution 🙌

Pour toute question ou problème, veuillez ouvrir une issue sur notre [dépôt GitHub](https://github.com/mus-inn/devcontainer-dotworld/issues). Les contributions sont les bienvenues. N'hésitez pas à proposer des améliorations ou à signaler des bugs.

Merci d'utiliser Dotinstall ! 🎉
