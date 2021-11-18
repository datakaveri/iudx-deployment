# Install
## Required secrets
```sh
secrets
|-- passwords
   |-- adminpassword
   |-- rspassword
   |-- authpassword
   `-- catpassword
```
Please see the example-secrets directory to get more idea, can use the 'secrets' in that directory by copying into root database directory  for demo or local testing purpose only! For other environment, please generate strong passwords.

## Build the docker file

```sh
docker build -t immudbconfiggenerator .
```

## Creating an overlay network
```sh
docker network create --driver overlay overlay-net
```

## Deploy

Bring up the immudb stack,
```sh
docker stack deploy -c immu-db-stack.yml immudb 
```
Bring up the config and basic schema generator stack(only on clean deployment),
```sh
docker stack deploy -c immudb-config-generator.yml tmp 

# Monitor logs to ensure creation
docker service logs tmp_immudbconfiggenerator -f

# Remove stack
docker stack rm tmp 
```
