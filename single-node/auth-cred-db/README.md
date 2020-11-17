# Install

## Required secrets

```sh
secrets/
`-- passwords
    |-- auth-cred-db-passwd
    |-- auth-cred-db-username
    |-- postgres-super-user-passwd
    `-- postgres-super-user-username

```
## Assign node labels

```sh
docker node update --label-add auth_cred_db_node=true <node_name>
```

## Deploy

### Production
```sh
# auth-cred-db listening at host's port 5432 
docker stack deploy -c auth-cred-db-stack.yml -c auth-cred-db-stack.prod.yml auth-cred-db
```
### Testing
```sh
# auth-cred-db, port not published to host
docker stack deploy -c auth-cred-db-stack.yml -c auth-cred-db-stack.test.yml auth-cred-db
```
### Devlopment
```sh
# auth-cred-db listening at host's port 5433
docker stack deploy -c auth-cred-db-stack.yml -c auth-cred-db-stack.dev.yml auth-cred-db
```
# Note
1. This service is split from databroker stack file. Assumes,
  'databroker\_db-volume' named volume to be present already, if not need to
  create the volume and then deploy.
2. Command to dump only psql data from a particular database of a dockerized psql.
```sh
docker exec <psqldb-container> pg_dump -a -U <username/role name>  <db_name> > <dump-file>.sql
```
3. Command to restore psql dump data (of a particular database) to dockerized  psql.

```sh
cat <dump_file>.sql | docker exec -i <psqldb-container> psql -U <username/role> -d <dbname>
```

