#!/bin/bash

OUTPUT_DIR="/home/lpaquatt/data/hugo"

# Vérifie si le dossier de sortie existe déjà
if [ -d "$OUTPUT_DIR" ]; then
    echo "Le site est déjà généré dans '$OUTPUT_DIR'."
else
    echo "Génération du site avec un conteneur Docker Hugo..."
    # Lancer un conteneur Hugo pour générer le site
	docker build -t hugo ./srcs/requirements/bonus/hugo
    docker run --rm -v $OUTPUT_DIR:/public hugo

fi
