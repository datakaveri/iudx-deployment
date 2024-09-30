## Getting started with Superset(visualization tool) using docker swarm Deploy

To be begin with, in order to deploy superset stack first we need to pass appropriate environment variables to customize superset and to establishes connection with backend components.

#### Setting up environment variables:

- Create `.env` (hidden) file at the same directory level as your docker stack file.
- Copy `superset_env_file` content into `.env` file and replace placeholders with actual values.


#### To deploy:
```sh
docker stack deploy -c superset-stack.yaml superset
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

