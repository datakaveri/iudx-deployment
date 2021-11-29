# Install
Following deployments assume, there is a docker swarm and  docker overlay network called "overlay-net"  in the swarm. Please [refer](../../../docs/swarm-setup.md) to bring up docker swarm and the network.
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
You can contsrain the postgres container to run on specifc node by adding node labels, refer [here](https://docs.docker.com/engine/swarm/services/#placement-constraints) for more info
```sh
docker node update --label-add postgres_db_node=true <node_name>
```

## Deploy

Three ways to deploy, do any one of it
1. Quick deploy (does not require assigning node labels)
```sh
docker stack deploy -c postgres-stack.yml postgres
```

2. Setting node constraints (needs assigning of node labels),resource reservations,limits in 'postgres-stack.resources.yml' file and then deploying (see [here](example-postgres-stack.resources.yml) for example configuration of 'postgres-stack.resources.yml' file ).

```sh
docker stack deploy -c postgres-stack.yml -c postgres-stack.resources.yml postgres
```
3. You can add more custom stack cofiguration in file 'postgres-stack.custom.yml' that ooverrides base 'postgres-stack.yml' file like ports mapping etc ( see [here](example-postgres-stack.custom.yml) for example configuration of 'postgres-stack.custom.yml' file)  and bring up like as follows
```sh
docker stack deploy -c postgres-stack.yml -c postgres-stack.resources.yml -c postgres-stack.custom.yml
```
Please refer [here](https://docs.docker.com/compose/extends/#multiple-compose-files) for info on why and how to use multiple stack files.

# Note
1. Command to dump only psql data from a particular database of a dockerized psql.
```sh
docker exec <psqldb-container> pg_dump -a -U <username/role name>  <db_name> > <dump-file>.sql
```
2. Command to restore psql dump data (of a particular database) to dockerized  psql.

```sh
cat <dump_file>.sql | docker exec -i <psqldb-container> psql -U <username/role> -d <dbname>
```

