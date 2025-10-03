# Stack PHP 8.4 avec FrankenPHP pour Laravel Octane

Cette stack est optimisée pour développer des applications Laravel avec **Laravel Octane** et **FrankenPHP**.

## 🚀 Qu'est-ce que FrankenPHP ?

FrankenPHP est un serveur d'application PHP moderne écrit en Go qui offre :
- **Performance ultra-rapide** avec mode worker
- Support **HTTP/2** et **HTTP/3**
- Support natif de **Laravel Octane**
- Compression Brotli et Zstandard
- Certificats HTTPS automatiques
- Worker mode pour garder votre application en mémoire

## 📦 Contenu de la stack

- **PHP 8.4** avec toutes les extensions nécessaires
- **FrankenPHP** pour servir votre application
- **Node.js 22** pour le build frontend
- **MySQL 8.0** pour la base de données
- **Redis** pour le cache et les sessions
- **Composer** pour les dépendances PHP

## 🛠️ Extensions PHP installées

Toutes les extensions requises pour Laravel sont pré-installées :
- pdo_mysql, pdo_sqlite
- gd, imagick
- intl, mbstring
- zip, xml
- opcache (activé en CLI)
- redis, memcached
- swoole (pour Octane)
- pcov (pour les tests de couverture)
- curl, soap, bcmath, readline, ldap

## 🎯 Commandes disponibles

### Initialisation du projet
```bash
# Initialise le projet complet (composer, npm, migrations, etc.)
install
```

### Démarrage du serveur

```bash
# Méthode 1 : Commande complète
php artisan octane:start --server=frankenphp --host=0.0.0.0 --port=80

# Méthode 2 : Commande custom
serve

# Méthode 3 : Commande octane avec auto-reload
octane --watch

# Méthode 4 : Alias
octane          # Lance Octane
octane-watch    # Lance Octane en mode watch
```

### Autres commandes
```bash
artisan         # Lance artisan de manière interactive
run             # Lance la compilation frontend (npm run watch)
xdebug          # Installe et configure Xdebug
```

## 📝 Configuration Laravel Octane

### Installation d'Octane dans un projet existant

```bash
composer require laravel/octane
php artisan octane:install --server=frankenphp
```

### Vérification des extensions PHP

Toutes les extensions sont pré-installées et configurées. Pour vérifier :

```bash
php -m | grep -E "(gd|intl|swoole|redis|memcached)"
```

Si vous voyez des warnings au démarrage sur `libavif`, `libcares` ou `libhashkit`, c'est que l'image doit être rebuildée avec les dernières modifications

### Configuration recommandée

Dans votre fichier `config/octane.php` :

```php
return [
    'server' => env('OCTANE_SERVER', 'frankenphp'),
    
    'frankenphp' => [
        'host' => env('OCTANE_HOST', '0.0.0.0'),
        'port' => env('OCTANE_PORT', 80),
        'workers' => env('OCTANE_WORKERS', 4),
        'max_requests' => env('OCTANE_MAX_REQUESTS', 500),
    ],
    
    'watch' => [
        'app',
        'bootstrap',
        'config',
        'database',
        'resources/**/*.php',
        'routes',
    ],
];
```

### Variables d'environnement

Ajoutez dans votre `.env` :

```env
OCTANE_SERVER=frankenphp
OCTANE_HOST=0.0.0.0
OCTANE_PORT=80
OCTANE_WORKERS=4
OCTANE_MAX_REQUESTS=500
```

## ⚡ Performance

Avec FrankenPHP et Laravel Octane, vous obtiendrez :
- **2-3x plus rapide** que PHP-FPM traditionnel
- Application gardée en mémoire entre les requêtes
- Temps de réponse réduits de manière significative

## 🐛 Debug avec Xdebug

Pour installer et configurer Xdebug :

```bash
xdebug
```

La configuration est automatiquement ajoutée avec :
- Port : 9003
- IDE Key : dotworld
- Host : host.docker.internal

## 📌 Ports exposés

- **80** : HTTP
- **443** : HTTPS
- **6001** : WebSockets
- **3306** : MySQL
- **6379** : Redis

## ⚠️ Important à savoir

### Variables globales et statiques

Avec Octane, votre application reste en mémoire entre les requêtes. Faites attention à :
- Ne pas utiliser de variables statiques qui accumulent des données
- Toujours nettoyer les ressources (connexions, fichiers, etc.)
- Utiliser les [Octane-safe patterns](https://laravel.com/docs/octane#managing-memory-leaks)

### Tests

Pour tester sans Octane :
```bash
php artisan serve
```

## 🔗 Ressources

- [Documentation Laravel Octane](https://laravel.com/docs/octane)
- [Documentation FrankenPHP](https://frankenphp.dev/)
- [Guide Dotworld](https://tinyurl.com/guide-dev)

## 👨‍💻 Auteur

Maintenu par l'équipe Dotworld

