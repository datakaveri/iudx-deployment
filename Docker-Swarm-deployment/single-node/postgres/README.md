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

```sh
docker stack deploy -c postgres-stack.yml postgres
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

