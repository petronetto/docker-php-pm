FROM php:cli

RUN apt-get update && apt-get install -y \
    git \
    unzip \
    nano \
    apache2-utils

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer --version
#ADD ./Composer /root/.composer/cache/
# Set timezone
# RUN rm /etc/localtime
# RUN ln -s /usr/share/zoneinfo/Europe/Paris /etc/localtime
# RUN "date"

# Type docker-php-ext-install to see available extensions
RUN docker-php-ext-install pdo pdo_mysql opcache pcntl


RUN pecl install apc \
    docker-php-ext-enable apc
# install xdebug
#RUN pecl install xdebug
##RUN docker-php-ext-enable xdebug
#RUN echo "error_reporting = E_ALL" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
#RUN echo "display_startup_errors = On" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
#RUN echo "display_errors = On" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
#RUN echo "xdebug.remote_enable=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
#RUN echo "xdebug.remote_connect_back=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
#RUN echo "xdebug.idekey=\"PHPSTORM\"" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
#RUN echo "xdebug.remote_port=9001" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo ";disable_functions = pcntl_alarm,pcntl_fork" >> /usr/local/etc/php/conf.d/docker-php-php.ini
RUN echo "zend.enable_gc = 0" >> /usr/local/etc/php/conf.d/docker-php-ext-zend.ini
#RUN docker-php-ext-disable xdebug
ADD .bashrc /root/
RUN echo 'alias sf="php app/console"' >> ~/.bashrc
RUN echo 'alias sf3="php bin/console"' >> ~/.bashrc
RUN mkdir /app
RUN ln -s /usr/local/bin/php /usr/bin/php7.0-cgi

RUN curl -L -o /tmp/php-pm.tar.gz https://github.com/php-pm/php-pm/archive/master.tar.gz && \
    tar -xzf /tmp/php-pm.tar.gz -C / && \
    composer install -d /php-pm-master && \
    ln -s /php-pm-master/bin/ppm /usr/local/bin/ppm && \
    #ln -s `pwd`/bin/ppm /usr/local/bin/ppm && \
    ppm --help

#RUN ln -s /php-pm-master/bin/ppm /usr/local/bin/ppm
ENV TERM=xterm-256color
# RUN composer create-project symfony/framework-standard-edition symfony

#RUN mkdir /app/
WORKDIR /app

# Entry point
EXPOSE 8080

CMD ["ppm", "start", "--cgi-path=/usr/bin/php7.0-cgi","--bootstrap=Laravel","--bridge=HttpKernel","--socket-path=/root/ppm/run"]
# CMD ["ppm", "start"]
