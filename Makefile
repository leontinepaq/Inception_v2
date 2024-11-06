SRCS =	srcs/requirements/mariadb/dockerfile\
		srcs/requirements/nginx/dockerfile\
		srcs/requirements/wordpress/dockerfile\

all:		generate_site up

generate_site:
			mkdir -p /home/lpaquatt/data/hugo
			@bash srcs/generate-site.sh

up:
			mkdir -p /home/lpaquatt/data/db
			mkdir -p /home/lpaquatt/data/wp
			docker compose -f ./srcs/docker-compose.yml up -d --build

down:
			docker compose -f ./srcs/docker-compose.yml down 

stop:
			docker compose -f ./srcs/docker-compose.yml stop

delete_volumes:		down
			docker volume prune
			docker volume rm db wp hugo
			sudo rm -rf /home/lpaquatt/data/wp /home/lpaquatt/data/db /home/lpaquatt/data/hugo

reset:		delete_volumes
			docker rmi wordpress nginx mariadb hugo
			docker system prune 

