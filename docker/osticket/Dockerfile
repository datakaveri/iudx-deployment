# Dockerfile for osTicket with OAuth2

FROM php:8.2-apache

# Install system deps & PHP extensions
RUN apt-get update \
 && apt-get install -y \
      libicu-dev libxml2-dev libpng-dev libzip-dev unzip git \
 && docker-php-ext-install intl xml gd mysqli zip opcache \
 && a2enmod rewrite

WORKDIR /var/www/html

# Clone osTicket (latest main branch)
COPY . .

# Setup OAuth2 plugin
RUN git clone --depth 1 https://github.com/osTicket/osTicket-plugins.git /tmp/plugins \
 && mv /tmp/plugins/* include/plugins \
 && cd include/plugins \
 && php make.php hydrate

# Build and install each plugin PHAR
RUN cd include/plugins \
&& php -dphar.readonly=0 make.php build auth-oauth2 
# && mv auth-oauth2/plugin.phar /var/www/html/include/plugins/auth-oauth2.phar

# Cleanup
# RUN rm -rf /tmp/osTicket-plugins \
#  && chown -R www-data:www-data /var/www/html

# Setup configuration file and permissions
RUN mkdir -p /var/www/html/include \
 && cp include/ost-sampleconfig.php /var/www/html/include/ost-config.php \
 && chmod 0666 /var/www/html/include/ost-config.php \
 && chown www-data:www-data /var/www/html/include/ost-config.php

# Fix ownership
RUN chown -R www-data:www-data /var/www/html

EXPOSE 80
CMD ["apache2-foreground"]
