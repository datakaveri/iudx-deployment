## Getting started with Superset(visualization tool) using docker swarm Deploy

#### To deploy superset dashboard:
```sh
docker stack deploy -c superset-stack.yaml superset
```
#### To deploy superset middleware:
```sh
cd gra-superset-guesttoken-middlware/
```
```sh
docker stack deploy -c superset-middleware-stack.yaml superset-middleware
```
#### To Check the status :
```sh
docker service ls

ID             NAME                                  MODE             REPLICAS              IMAGE                                                     PORTS
                                         
7ztp4yx1d1gc   superset_redis                        replicated       1/1                   redis:7                                                   
k2lkdttsrgrw   superset_superset                     replicated       1/1                   ghcr.io/datakaveri/superset:4.0.2-1                       *:8088->8088/tcp
ijzzqgxx8rd1   superset_superset-worker              replicated       1/1                   ghcr.io/datakaveri/superset:4.0.2-1                       
x1ojkx3smg0y   superset_superset-worker-beat         replicated       1/1                   ghcr.io/datakaveri/superset:4.0.2-1                       
rv2yw340gsd0   superset_superset_init                replicated       0/1                   ghcr.io/datakaveri/superset:4.0.2-1                       
```

**superset_superset_init** service will be down once it performs bootstrap operations.

##### NOTE: 
1. To install custom modules add them in docker/requirements-local.txt file and redeploy the stack
2. Replace all placeholder in .env and client-secret.json under secrets/ and .env file under gra-superset-guesttoken-middleware/
