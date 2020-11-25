#################################
#### Author: Danilo Alves       #
#### Email: daniloha7@gmail.com #
#################################

# Offical Wordpress Image:
FROM wordpress:5.5.1-php7.4-apache

# Install requirements
RUN apt update && \
    apt install -y curl

# Install WP CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    php wp-cli.phar --info && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp && \
    wp --info

# Install Plugin
# USER www-data
# RUN wp plugin install rock-convert --activate --path='/usr/src/wordpress'