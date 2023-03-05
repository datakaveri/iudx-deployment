# Nginx
Docker image for Nginx

## Build nginx with [headers-more module](https://www.nginx.com/resources/wiki/modules/headers_more/)

```sh
docker build -f Dockerfile --build-arg ENABLED_MODULES="headers-more" --build-arg  nginx_version=1.20 -t ghcr.io/datakaveri/nginx:1.20 .
```
The Dockerfile (Dockerfile.alpine) containing the building and including external module to nginx docker image is obtained [here](https://github.com/nginxinc/docker-nginx/tree/master/modules).
