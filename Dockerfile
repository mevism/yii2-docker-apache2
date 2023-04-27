FROM  php:8.2.3-apache-bullseye

ENV ADMIN_EMAIL webmaster@localhost
ENV PHP_TIME_ZONE Africa/Nairobi
ENV PHP_MEMORY_LIMIT 128M
ENV PHP_UPLOAD_MAX_FILESIZE 32M
ENV PHP_POST_MAX_SIZE 32M

COPY 000-default.conf $APACHE_CONFDIR/sites-available/000-default.conf
COPY php-override.ini $PHP_INI_DIR/conf.d/php-override.ini

RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		acl \
		bash \
		cron \
		curl \
		gettext \
		git \
		libicu-dev \
		libjpeg-dev \
		libfreetype6-dev \
		libmagickwand-dev \
		libonig-dev \
		libpng-dev \
		libpq-dev \
		libwebp-dev \
		libxml2-dev \
		libzip-dev \
		zip \
		zlib1g-dev \
		grep \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

#
# CRON
#

RUN mkdir -m 0644 -p /etc/cron.d \
	&& mkdir -m 0644 -p /var/log/cron \
	&& touch /var/log/cron/cron.log

#
# COMPOSER
#

RUN curl -sS https://getcomposer.org/installer | php \
	&& mv composer.phar /usr/local/bin/composer \
	&& composer self-update

#
# PHP extensions
#

RUN pecl install imagick \
	&& docker-php-ext-configure gd \
		--with-freetype \
		--with-jpeg \
		--with-webp \
	&& docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
	&& docker-php-ext-configure bcmath --enable-bcmath \
	&& docker-php-ext-install \
		bcmath \
		exif \
		gd \
		gettext \
		intl \
		mysqli \
		opcache \
		pdo_mysql \
		pdo_pgsql \
		pgsql \
		zip \
	&& docker-php-ext-enable \
		imagick

#
# Apache
#

RUN a2enmod rewrite \
	&& a2enmod http2 \
	&& ln -sf /dev/stdout /var/log/apache2/access.log \
	&& ln -sf /dev/stderr /var/log/apache2/error.log