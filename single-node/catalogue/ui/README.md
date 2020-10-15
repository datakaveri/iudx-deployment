# Directory Structure
```sh
.
|-- README.md
`-- docker
    |-- Dockerfile 
    |-- copy-ui.sh (copies the built ui to mounted location in production)
    `-- docker-build.sh (script build and push the docker image)
```
# Reload-UI pipeline
## Build 
```sh
# this builds the image with name abhiurn/cat-ui:latest and pushes it to abhiurn dockerhub repo
./docker/docker-build.sh
```
## Reload UI
At the swarm master node, 
``` sh
# reloads the ui (only when a new image is available in dockerhub)
docker stack deploy -c ../nginx/cat-nginx.yml cat-nginx

# to monitor successuful reload (see the latest timed log)
docker service logs  -t  cat-nginx_copy-catalogue-ui 
```

# Note
1) When CI/CD pipeline with local docker registry is functional,placing this build scripts in dk-customer-ui repo makes sense.
 - Whenever there is change is prod branch of UI, CI/CD pipeline triggers this
   build scripts and push the docker image to docker local registry
 - At the prodution need to update the  container docker image from this registry whenever
   new docker image build is pushed (just a thought). for this build container needs to
   be running continously, maybe with as a sleeping daemon. 
