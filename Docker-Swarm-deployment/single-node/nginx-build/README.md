# Build nginx with [headers-more module](https://www.nginx.com/resources/wiki/modules/headers_more/)
docker build -f Dockerfile.alpine  --build-arg ENABLED_MODULES="headers-more" -t <docker-registry-url>/<repo-name>/nginx:1.20 .

# Reference
1. The Dockerfile.alpine containing the building and including external module to nginx docker image is obtained [here](https://github.com/nginxinc/docker-nginx/tree/master/modules).
