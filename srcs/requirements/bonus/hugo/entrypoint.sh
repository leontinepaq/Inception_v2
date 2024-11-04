#!/bin/bash

hugo new site my_site
cd my_site

git init
git submodule add https://github.com/theNewDynamic/gohugo-theme-ananke.git themes/ananke
cp /var/site/hugo.toml .
cp -r /var/site/content/. ./content/
cp -r /var/site/static/. ./static/
hugo server -D --bind 0.0.0.0

