#!/bin/bash

# Hugo est un générateur de sites statiques qui transforme des fichiers Markdown 
# en pages web HTML. Il est principalement utilisé pour générer des fichiers HTML 
# que vous pouvez ensuite déployer sur un serveur web (comme Apache ou nginx).
# Hugo inclut un serveur de développement local, souvent utilisé sur le port 1313,
# pour prévisualiser les sites pendant leur création. Ce serveur est conçu pour un 
# usage temporaire en local, pas pour de la production. 

OUTPUT_DIR="/home/lpaquatt/data/hugo"

if [ -d "$OUTPUT_DIR" ] && [ ! -z "$(ls -A "$OUTPUT_DIR" 2>/dev/null)" ]; then
	echo "The site has already been generated in '$OUTPUT_DIR'."
else
	echo "Generating the static site with a Hugo Docker..."
	docker build -t hugo ./srcs/requirements/bonus/hugo
	docker run --rm  -d -p 1313:1313 -v $OUTPUT_DIR:/my_site/public hugo
fi
