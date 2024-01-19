#!/bin/sh

# Générer la clé uniquement si elle n'est pas déjà définie
if [ -z "$APP_KEY" ]; then
    php artisan key:generate
fi

php artisan config:cache
php artisan route:cache

# Démarrer le serveur web
php artisan serve --host=0.0.0.0 --port=8888
