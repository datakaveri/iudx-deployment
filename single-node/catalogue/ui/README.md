#Directory Structure
.
|-- README.md
`-- docker
    |-- Dockerfile 
    |-- copy-ui.sh (copies the built ui to mounted location in production)
    `-- docker-build.sh (script build and push the docker image)

#Build 
```sh
# this builds docker image with UI and has script to copy the built UI to mounted location
./docker/docker-build.sh

#Note
1) When CI/CD pipeline with local docker registry is functional,placing this build scripts in dk-customer-ui repo makes sense.
 - Whenever there is change is prod branch of UI, CI/CD pipeline triggers this
   build scripts and push the docker image to docker local registry
 - At the prodution need to update the  container docker image from this registry whenever
   new docker image build is pushed (just a thought). for this build container needs to
   be running continously, maybe with as a sleeping daemon. 
