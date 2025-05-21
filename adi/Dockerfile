FROM php:8.1-apache

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    libzip-dev \
    default-mysql-client \
    libmariadb-dev

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-install mysqli
RUN docker-php-ext-install mbstring exif pcntl bcmath gd zip intl

# Configure PHP
RUN echo "error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT & ~E_WARNING" > /usr/local/etc/php/conf.d/error_reporting.ini
RUN echo "display_errors = On" >> /usr/local/etc/php/conf.d/error_reporting.ini
RUN echo "display_startup_errors = Off" >> /usr/local/etc/php/conf.d/error_reporting.ini
RUN echo "log_errors = On" >> /usr/local/etc/php/conf.d/error_reporting.ini

# Install Node.js and npm
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# Enable Apache modules
RUN a2enmod rewrite
RUN a2enmod headers

# Configure Apache
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf
RUN sed -i 's/AllowOverride None/AllowOverride All/g' /etc/apache2/apache2.conf

# Deny access to adi directory
RUN echo '<Directory "/var/www/html/adi">\n\
    Order deny,allow\n\
    Deny from all\n\
</Directory>' > /etc/apache2/conf-available/deny-adi.conf
RUN a2enconf deny-adi

# Set working directory
WORKDIR /var/www/html

# Copy application files
COPY . .

# Ensure .htaccess has correct permissions
RUN chmod 644 .htaccess

# Install Node.js dependencies
RUN npm install

# Create and set permissions for files directory
RUN mkdir -p /var/www/html/files \
    && chown -R www-data:www-data /var/www/html/files \
    && chmod -R 775 /var/www/html/files

# Set permissions for the rest of the application
RUN chown -R www-data:www-data /var/www/html

# Expose port
EXPOSE 80

# Start Apache
CMD ["apache2-foreground"] 