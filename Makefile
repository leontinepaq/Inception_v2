SRCS =	srcs/requirements/mariadb/dockerfile\
		srcs/requirements/nginx/dockerfile\
		srcs/requirements/wordpress/dockerfile

all:		generate_site up

generate_site:
			mkdir -p /home/lpaquatt/data/hugo
			@bash srcs/generate-site.sh

up:
			mkdir -p /home/lpaquatt/data/db
			mkdir -p /home/lpaquatt/data/wp
			mkdir -p /home/lpaquatt/data/redis
			docker compose -f ./srcs/docker-compose.yml up -d --build

up_no_build:
			mkdir -p /home/lpaquatt/data/db
			mkdir -p /home/lpaquatt/data/wp
			mkdir -p /home/lpaquatt/data/redis
			docker compose -f ./srcs/docker-compose.yml up -d 

down:
			docker compose -f ./srcs/docker-compose.yml down 

stop:
			docker compose -f ./srcs/docker-compose.yml stop

reset:		
			docker compose -f ./srcs/docker-compose.yml down
			docker rmi wordpress nginx mariadb redis hugo
			docker volume rm db wp redis hugo
			sudo rm -rf /home/lpaquatt/data/wp /home/lpaquatt/data/db /home/lpaquatt/data/redis /home/lpaquatt/data/hugo
			docker system prune 

delete_volumes:
			docker compose -f ./srcs/docker-compose.yml down
			docker volume prune
			docker volume rm db wp redis hugo
			sudo rm -rf /home/lpaquatt/data/wp /home/lpaquatt/data/db /home/lpaquatt/data/redis /home/lpaquatt/data/hugo
