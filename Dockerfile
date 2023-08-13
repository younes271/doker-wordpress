FROM	debian:buster

COPY	srcs/nginx.conf ./
COPY	srcs/init_container.sh ./
COPY	srcs/start.sql ./
COPY	srcs/wp-config.php ./

CMD		bash init_container.sh && bash 

