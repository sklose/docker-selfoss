FROM php:5.6-apache
MAINTAINER Jens Erat <email@jenserat.de>

# Remove SUID programs
RUN for i in `find / -perm +6000 -type f`; do chmod a-s $i; done

# selfoss requirements: mod-headers, mod-rewrite, gd
RUN a2enmod headers rewrite && \
    apt-get update && \
    apt-get install -y unzip && \
    apt-get install -y libpng12-dev && \
    docker-php-ext-install gd

ADD https://github.com/SSilence/selfoss/archive/master.zip /tmp/
RUN unzip /tmp/master.zip -d /var/www/html && \
    rm /tmp/master.zip /var/www/html/index.html && \
    ln -s /app/config/config.ini /var/www/html && \
    chown -R www-data:www-data /var/www/html

# Extend maximum execution time, so /refresh does not time out
COPY php.ini /usr/local/etc/php/

VOLUME /app/config
