# Nginx-acme
Docker image for Nginx with automated cert generation and renewal using acme.sh

```sh
docker build -f Dockerfile --build-arg ENABLED_MODULES="headers-more" --build-arg  nginx_version=1.25 -t ghcr.io/datakaveri/nginx-acme:1.25 .

```
