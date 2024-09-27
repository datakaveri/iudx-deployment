
## Superset:
 
 The `Dockerfile` has neccessary scripts needed to run superset - a data visualization and data exploration platform.

 `docker` directory consists of neccessary file and scripts to bootstrap and run processes to bring up superset.


## TL;DR

1.  `docker-bootstrap.sh` - This script install neccessary python modules which are defined in **/docker/requirements-local.txt** file
2. `docker-init.sh`: This script upgrades schema( in postgres) for superset and setup admin user and password for superset
3. `run-server.sh`: This script runs actual flask app i.e., superset

## Build Docker Image
```sh
docker build -t ghcr.io/datakaveri/superset:4.0.2-1
```


