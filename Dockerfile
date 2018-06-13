FROM alpine:latest

RUN set -x ; \
  addgroup -g 82 -S www-data ; \
  adduser -u 82 -D -S -G www-data www-data && exit 0 ; exit 1
  
RUN apk --update add \
  nginx \
  php7 \
  php7-fpm \
  php7-pdo \
  php7-json \
  php7-mysqli \
  php7-pdo_mysql \
  supervisor

RUN mkdir -p /etc/nginx && \
	mkdir -p /var/run/php-fpm && \
	mkdir -p /var/run/nginx && \
	mkdir -p /var/log/supervisor

RUN rm /etc/nginx/conf.d/default.conf
RUN rm /etc/php7/php-fpm.d/www.conf

ADD conf/supervisord.conf /etc/supervisord.conf
ADD conf/nginx_app.conf /etc/nginx/conf.d/nginx_app.conf
ADD conf/nginx.conf /etc/nginx/nginx.conf
ADD conf/www.conf /etc/php7/php-fpm.d/www.conf

WORKDIR /app
COPY www /app/www
RUN chown -R www-data:www-data /app/www

EXPOSE 80

CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisord.conf"]