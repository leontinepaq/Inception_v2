#!/bin/bash

OUTPUT_DIR="/home/lpaquatt/data/hugo"

if [ -d "$OUTPUT_DIR" ] && [ ! -z "$(ls -A "$OUTPUT_DIR" 2>/dev/null)" ]; then
	echo "The site has already been generated in '$OUTPUT_DIR'."
else
	echo "Generating the static site with a Hugo Docker..."
	if [ "$(docker ps -q -f name=hugo)" ]; then
		docker stop hugo
	fi
	docker build -t hugo ./srcs/requirements/bonus/hugo
	PORT=1313
	if lsof -i :$PORT >/dev/null 2>&1; then
		echo "Port $PORT is already used. Impossible to run the Docker"
		exit 1
	else
		docker run --rm -d -p 1313:1313 -v "$OUTPUT_DIR:/my_site/public" hugo
	fi
fi
