# Install

## Required secrets

```sh
secrets/
└── passwords
    ├── postgres-auth-password
    ├── postgres-keycloak-password
    ├── postgresql-password
    └── postgres-rs-password
```
## Assign node labels

```sh
docker node update --label-add postgres_db_node=true <node_name>
```

## Deploy
Three ways to deploy, do any one of it
1. Quick deploy 
```sh
docker stack deploy -c postgres-stack.yml postgres
```

2. Setting resource reservations,limits in postgres-stack.resources.yml file and then deploying (see [here](example-postgres-stack.resources.yml)).

```sh
docker stack deploy -c postgres-stack.yml -c postgres-stack.resources.yml postgres
```
3. You can add more custom stack cofiguration in file 'postgres-stack.custom.yml' like ports mapping etc and bring up like as follows
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

