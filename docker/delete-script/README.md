# Docker image of delete subscription script
This image contains a delete script, which will delete the subscription once its expiry time has passed.

# Build and push  docker image
docker build -t ghcr.io/datakaveri/rs-refresh-script:\<tag\> -f Dockerfile . && docker push ghcr.io/datakaveri/rs-refresh-script:\<tag\> 
