hugo new site quickstart
cd quickstart
git init
git submodule add https://github.com/theNewDynamic/gohugo-theme-ananke.git themes/ananke
echo "theme = 'ananke'" >> hugo.toml

hugo new content content/posts/my-first-post.md
hugo new content/posts/my-first-post.md
echo "## Introduction

This is **bold** text, and this is *emphasized* text.

Visit the [Hugo](https://gohugo.io) website!" >> content/content
hugo server -D --bind 0.0.0.0

https://www.digitalocean.com/community/tutorials/how-to-install-go-on-debian-10
