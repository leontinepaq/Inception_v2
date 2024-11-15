#!/bin/bash

OUTPUT_DIR="/home/lpaquatt/data/hugo"
BASE_REPO="./srcs/requirements/bonus/hugo/site"
MODIF_REPO="./srcs/requirements/bonus/hugo_dev/site"

# Confirm deleting the published site in the volume
if [ -d "$OUTPUT_DIR/site" ] && [ ! -z "$(ls -A "$OUTPUT_DIR/site" 2>/dev/null)" ]; then
	read -p "Are you sure you want to delete the current site in '$OUTPUT_DIR'? (y/n): " confirm
	if [[ "$confirm" != [yY] ]]; then
		echo "Modification canceled"
		exit 1
	fi
	echo "Deleting the site already present in '$OUTPUT_DIR'."
	sudo rm -rf "$OUTPUT_DIR"
fi
mkdir -p "$OUTPUT_DIR"

# Copying the site from the base repository
if [ -d "$MODIF_REPO" ]; then
	rm -r "$MODIF_REPO"
fi 
cp -r "$BASE_REPO" "$MODIF_REPO"

# Launching the docker
echo "Launching Hugo docker to build the static site..."
if [ "$(docker ps -q -f name=hugo_dev)" ]; then
	docker stop hugo_dev
fi
docker build -t hugo_dev ./srcs/requirements/bonus/hugo_dev
docker run --rm -d --name hugo_dev -p 1313:1313 -v $OUTPUT_DIR:/my_site/public hugo_dev

rm -r "$MODIF_REPO"

echo "Waiting for /my_site directory to be created in the container..."
until docker exec hugo_dev test -d /my_site/  ; do
  sleep 2
done

# Interactive shell to help modifications
echo "-------------------------------------------"
echo "You can modify the content of the site in /my_site/content/ and visualise it at localhost:1313"
echo "Once you are happy with the result you can exit the container."
echo "-------------------------------------------"

docker exec -it --workdir /my_site hugo_dev bash

# Ask user if they want to publish the site
read -p "Would you like to publish the site? (y/n): " confirm_publish
if [[ "$confirm_publish" == [yY] ]]; then
    echo "Publishing the site in '$OUTPUT_DIR'"
	docker exec hugo_dev hugo -s /my_site -d /my_site/public
else
	sudo rm -rf "$OUTPUT_DIR"
fi

# Ask user if they want to copy the modified site back to the base repository
read -p "Would you like to save the modified site to the base repository? (y/n): " copy_confirm
if [[ "$copy_confirm" == [yY] ]]; then
    echo "Copying modified site from container to '$BASE_REPO'..."
    docker cp hugo_dev:/my_site "$BASE_REPO"
    echo "Site copied to '$BASE_REPO'."
else
    echo "Changes were not copied to the base repository."
fi

# Ask user if they want to stop the container
read -p "Would you like to stop the container? (y/n): " stop_container
if [[ "$stop_container" == [yY] ]]; then
    echo "Stopping container hugo_dev"
    docker stop hugo_dev
fi
