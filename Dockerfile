FROM debian:jessie
MAINTAINER Warren Seymour <warren@radify.io>

RUN apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62
RUN echo "deb http://nginx.org/packages/debian jessie nginx" >> /etc/apt/sources.list

RUN apt-get update && \
    apt-get install -y \
	ca-certificates \
	nginx \
	php5-fpm \
	supervisor \
	&& \
    rm -rf /var/lib/apt/lists/*

COPY supervisord.conf /etc/supervisor/conf.d/nginx-php-fpm.conf

RUN rm /etc/nginx/conf.d/* && \
	echo "daemon off;" >> /etc/nginx/nginx.conf
COPY nginx.conf /etc/nginx/conf.d/php-fpm.conf

RUN sed -i -e "s/listen = \/var\/run\/php5-fpm.sock/listen = 127.0.0.1:9000/g" /etc/php5/fpm/pool.d/www.conf

EXPOSE 80 443
ENTRYPOINT ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/nginx-php-fpm.conf"]
