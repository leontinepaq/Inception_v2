create_dirs:
				@mkdir -p /home/lpaquatt/data/hugo /home/lpaquatt/data/db /home/lpaquatt/data/wp

generate_site: 	create_dirs
				@bash srcs/generate-site.sh

modify_site: 	create_dirs
				@bash srcs/modify-site.sh

rm_site:
				@docker volume ls -q | grep -q hugo && docker volume rm hugo || echo "Volume hugo already removed"
				@sudo rm -rf /home/lpaquatt/data/hugo

up: 			generate_site
				docker compose -f ./srcs/docker-compose.yml up -d --build

down:
				docker compose -f ./srcs/docker-compose.yml down 

stop:
				docker compose -f ./srcs/docker-compose.yml stop

delete_volumes: down rm_site
				docker volume ls -q | grep -q db && docker volume rm db || echo "Volume db already removed"
				docker volume ls -q | grep -q wp && docker volume rm wp || echo "Volume wp already removed"
				docker volume prune
				sudo rm -rf /home/lpaquatt/data/db /home/lpaquatt/data/wp

reset: 			delete_volumes
				docker rmi wordpress nginx mariadb hugo hugo_dev ftp redis adminer
				docker system prune -af

clean:
				docker system prune -af
