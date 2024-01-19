# Utiliser une image PHP avec Composer préinstallé pour la construction
FROM composer:latest as build

WORKDIR /app

COPY . /app

# Afficher le contenu du répertoire de construction pour le débogage
RUN ls -al

# Installer les dépendances (y compris les extensions PHP requises)
RUN set -ex \
    && apk --no-cache add \
        libexif \
        libexif-dev \
    && docker-php-ext-configure exif \
    && docker-php-ext-install exif \
    && composer install

# Utiliser une image PHP avec le serveur web intégré de Laravel
FROM php:latest

WORKDIR /var/www/html

# Copier l'application Laravel construite depuis l'image Composer
COPY --from=build /app /var/www/html

# Copier le script d'entrée directement dans le répertoire / du conteneur
COPY ./entrypoint.sh /entrypoint.sh

# Exposer le port 8000 utilisé par le serveur web intégré de Laravel
EXPOSE 8000

# Commande pour démarrer le serveur web intégré de Laravel
CMD ["sh", "/entrypoint.sh"]
