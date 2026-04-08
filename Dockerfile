# Gunakan image PHP ringan
FROM php:8.2-fpm-alpine

# Install dependency yang dibutuhkan Laravel
RUN apk add --no-cache \
    libpng-dev \
    libjpeg-turbo-dev \
    libzip-dev \
    oniguruma-dev \
    icu-dev \
    bash \
    git \
    unzip \
    curl \
    && docker-php-ext-install \
        pdo_mysql \
        mbstring \
        zip \
        gd \
        intl \
        opcache

# Install Composer
COPY --from=composer:2.7 /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Copy semua file project
COPY . .

# Install dependency Laravel (tanpa dev)
RUN composer install --no-dev --optimize-autoloader

# Set permission
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Expose port
EXPOSE 9000

# Jalankan PHP-FPM
CMD ["php-fpm"]