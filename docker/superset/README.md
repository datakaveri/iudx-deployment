
## Superset (a data visualization and data exploration platform)
 
 We are creating custom `Dockerfile` which has neccessary scripts to run and bootstrap superset, on top of official superset image

 `docker` directory consists of neccessary scripts to bring up superset


## TL;DR

1.  `docker-bootstrap.sh` - This script installs neccessary python modules which are defined in **/docker/requirements-local.txt** file
2. `docker-init.sh`: This script upgrades schema and setup admin user and password for superset
3. `run-server.sh`: This script runs actual flask app i.e., superset

## Build Docker Image
```sh
docker build -t ghcr.io/datakaveri/superset:4.0.2-1
```


