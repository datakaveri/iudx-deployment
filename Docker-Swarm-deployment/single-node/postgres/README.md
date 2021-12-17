# Install
Following deployments assume, there is a docker swarm and  docker overlay network called "overlay-net"  in the swarm. Please [refer](../../../docs/swarm-setup.md) to bring up docker swarm and the network.

 [bitnami postgres image](https://github.com/bitnami/bitnami-docker-postgresql) is used for postgres.
## Required secrets

```sh
secrets/
└── passwords
    ├── postgres-auth-password
    ├── postgres-keycloak-password
    ├── postgresql-password
    └── postgres-rs-password
```
Please see the example-secrets directory to get more idea, can use the 'secrets' in that directory by copying into root postgres  directory for demo or local testing purpose only! For other environment, please generate strong passwords.

## Assign node labels
 The postgres container is constrained to run on specifc node by adding node labels to only one of the nodes, refer [here](https://docs.docker.com/engine/swarm/services/#placement-constraints) for more info. This ensures the container is placed always to same node on restart and able to mount the same local docker volume.
```sh
docker node update --label-add postgres_db_node=true <node_name>
```

## Deploy

Three ways to deploy, do any one of it
1. Quick deploy  
```sh
docker stack deploy -c postgres-stack.yml postgres
```

2. Setting resource reservations,limits in 'postgres-stack.resources.yml' file and then deploying (see [here](example-postgres-stack.resources.yml) for example configuration of 'postgres-stack.resources.yml' file ).

```sh
docker stack deploy -c postgres-stack.yml -c postgres-stack.resources.yml postgres
```
3. You can add more custom stack cofiguration in file 'postgres-stack.custom.yml' that overrides base 'postgres-stack.yml' file like ports mapping etc ( see [here](example-postgres-stack.custom.yml) for example configuration of 'postgres-stack.custom.yml' file)  and bring up like as follows
```sh
docker stack deploy -c postgres-stack.yml  -c postgres-stack.custom.yml postgres
```
or 
with resource limits, reservations
```sh
docker stack deploy -c postgres-stack.yml -c postgres-stack.resources.yml -c postgres-stack.custom.yml postgres
```

# Note
1. Command to dump only psql data from a particular database of a dockerized psql.
```sh
docker exec <psqldb-container> pg_dump -a -U <username/role name>  <db_name> > <dump-file>.sql
```
2. Command to restore psql dump data (of a particular database) to dockerized  psql.

```sh
cat <dump_file>.sql | docker exec -i <psqldb-container> psql -U <username/role> -d <dbname>
```
3. Please refer [here](https://docs.docker.com/compose/extends/#multiple-compose-files) for info on why and how to use multiple stack files.
4.  Following users using the passwords present at ```secrets/password/postgres-rs-password``` and dbs are created accordingly using init scripts present at ```init-scripts/```:

| Username           | Password                                    | Role/Access                         |  Services                     |
|:-------------------:|:------------------------------------------:| :---------------------------------: |:-----------------------------:|
| iudx_rs_user       | secrets/password/postgres-rs-password       | SELECT,INSERT,DELETE,UPDATE on tables of ```iudx_rs``` Database   | Used by resource server      |
| iudx_keycloak_user | secrets/password/postgres-keycloak-password |  Owner of ```iudx_keycloak``` database                   | Used by keycloak server      |
| iudx_auth_user     |   secrets/password/postgres-auth-password   |   Access given while setting up auth server             | Used by auth server          |        | postgres           | secrets/password/postgresql-password     |     Superuser                                             |  Used to set users and RBAC  |
                            
