## Deployment of Superset using docker swarm
Superse is an open-source modern data exploration and visualization platform by Apache.

#### <u>Customising Superset:</u>
- Files enumerated below allows you to customise superset.
1)  **./config/superset_config.py**: It allows to override parameters to create your own configuration module.
2)  **./config/requirements-local.txt**: Add the extra packages to be installed here.
3)  **./config/client-secret.json**: Replace placeholders to configure superset with keycloak authorization. 
4)  **./secrets/.env**: Replace the placeholders to configure superset with backend databases and etc.

#### <u>Deploying Superset using stack file(s):</u>
```sh
cp example-superset.resources.yaml superset-resources.yaml
```

```sh 
docker stack deploy -c superset-stack.yaml -c superset-resources.yaml superset
```

#### <u>Superset middleware:</u>
Superset middleware is used to embed superset dashboards in the web application.

&nbsp;&nbsp;&nbsp;&nbsp;<u>deploying superset middleware using stack file(s):</u>

 ```sh
docker stack deploy -c superset-middleware-stack.yaml superset-middlware
```

#### Ouput to be expected:
```sh 
docker service ls

ID             NAME                                      MODE         REPLICAS   IMAGE                                                     PORTS
ajrirmroerdd   superset-middleware_superset-middleware   replicated   1/1        ghcr.io/datakaveri/superset-middleware:v4                 
uq8j3elyr8mm   superset_redis                            replicated   1/1        redis:7.4                                                 
r2boiwmxpmny   superset_superset                         replicated   1/1        ghcr.io/datakaveri/superset:4.0.2-8                       *:8088->8088/tcp
m7m7xdyp7e6y   superset_superset-worker                  replicated   1/1        ghcr.io/datakaveri/superset:4.0.2-8                       
ydv05twjmzt5   superset_superset-worker-beat             replicated   1/1        ghcr.io/datakaveri/superset:4.0.2-8                       
2huntcuvk1lv   superset_superset_init                    replicated   0/1        ghcr.io/datakaveri/superset:4.0.2-8                       

