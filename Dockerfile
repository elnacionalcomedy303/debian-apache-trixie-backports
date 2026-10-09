FROM debian:trixie-backports

RUN apt update
RUN apt install -y apache2 elinks

ADD mario.html /var/www/html

EXPOSE 80

WORKDIR /var/www/html

CMD ["apachectl","-D","FOREGROUND"]
