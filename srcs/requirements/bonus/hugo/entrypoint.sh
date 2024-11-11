#!/bin/bash

hugo new site my_site
cd my_site
git init
git submodule add https://github.com/theNewDynamic/gohugo-theme-ananke.git themes/ananke

#copy the config and site files from the repo
cp /var/site/hugo.toml .
cp -r /var/site/content/. ./content/
cp -r /var/site/static/. ./static/

#publish the site in the volume
hugo
