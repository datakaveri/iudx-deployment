# Introduction
Docker swarm stack for postgres deployment

## Postgres Installation
## Create secret files
1. To generate the passwords:

```console
./create-secrets.sh
```
2. Secrets directory after generation of passwords:
```sh
secrets/
└── passwords
    ├── postgres-auth-password
    ├── postgres-keycloak-password
    ├── postgresql-password
    └── postgres-rs-password

```
## Assign node labels
 The postgres container is constrained to run on specifc node by adding node labels to only one of the nodes, refer [here](https://docs.docker.com/engine/swarm/services/#placement-constraints) for more info. This ensures the container is placed always to same node on restart and able to mount the same local docker volume.
```sh
docker node update --label-add postgres-db-node=true <node_name>
```
## Define Appropriate values of resources

Define Appropriate values of resources -
- CPU 
- RAM 
- PID limit 
in `postgres-stack.resources.yaml`  for postgres as shown in sample resource-values file for [here](postgres-stack.resources.yaml)

## Deploy
Deploy Postgres stack:
```sh
docker stack deploy -c postgres-stack.yaml -c postgres-stack.resources.yaml postgres
```
## Postgres Users creation
1. Configure `init-script/db-user-creation-config.json` if any changes required
2. For Multi-tenancy, replace the prefix names of database and user with appropriate names. Below examples
```sh
"username": "<appropriate_prefix>_keycloak_user"
"database": "<appropriate_prefix>_keycloak",
```
For all users.

3. Bring up the db generator stack(only on clean deployment),
```sh
docker stack deploy -c db-user-creation.yaml tmp
```
4. Monitor logs to ensure creation
```sh
docker service logs tmp_db_user_creation -f
```
5. Remove stack, once users are created
```sh
docker stack rm tmp
```

## RS, auth scehma creation
The rs and auth schema created using flyway tool. Follow below steps:
1. Bind/publish/expose the psql port  5432 to host VM temporarily as described in 5th point in note

2. ``git clone  https://github.com/datakaveri/iudx-aaa-server.git && cd iudx-aaa-server`` repo and do following
  2.1 flyway.conf must be updated with the required data. which will be as follows
  ```
   flyway.url=jdbc:postgresql://127.0.0.1:5432/postgres
   flyway.user=postgres 
   flyway.password=<value in secrets/passwords/postgresql-password>  
   flyway.schemas=aaa 
   flyway.placeholders.authUser=iudx_auth_user 
  ```
  2.2 After this, the info command can be run to test the config. Then, the migrate command can be run to set up the database. At the /iudx-aaa-server directory, run

  ```
  mvn flyway:info -Dflyway.configFiles=flyway.conf
  mvn flyway:migrate -Dflyway.configFiles=flyway.conf
  ```
 Refer here for more info: https://github.com/datakaveri/iudx-aaa-server#flyway-database-setup
3. Similarly do for resource server,  ``git clone https://github.com/datakaveri/iudx-resource-server.git && cd iudx-resource-server``
  3.1 flyway.conf must be updated with the required data. which will be as follows
  ```
  flyway.url=jdbc:postgresql://127.0.0.1:5432/iudx_rs
  flyway.user=postgres
  flyway.password=<value in secrets/passwords/postgresql-password>
  flyway.schemas=public
  flyway.placeholders.rsUser=iudx_rs_user
  flyway.cleanDisabled=true
  # use TRUE only for first time migration of existing DB, else use FALSE.
  flyway.baselineOnMigrate = false
  ```
  2.2 After this, the info command can be run to test the config. Then, the migrate command can be run to set up the database. At the /iudx-resource-server directory, run
  ```
  mvn flyway:info -Dflyway.configFiles=flyway.conf
  mvn flyway:migrate -Dflyway.configFiles=flyway.conf
  ```
# Note
1. Command to dump only psql data from a particular database of a dockerized psql.
```sh
docker exec <psqldb-container> PGPASSWORD=`cat $POSTGRESQL_PASSWORD_FILE` pg_dumpall -U postgres > /tmp/dump.sql
```
2. Command to restore psql dump data (of a particular database) to dockerized  psql.

```sh
cat <dump_file>.sql | docker exec -i <psqldb-container> PGPASSWORD=`cat $POSTGRESQL_PASSWORD_FILE` psql -U postgres
```
3. Please refer [here](https://docs.docker.com/compose/extends/#multiple-compose-files) for info on why and how to use multiple stack files.
4.  Following users using the passwords present at ```secrets/passwords/``` directory and dbs are created accordingly using init scripts present at ```init-scripts/```:

| Username           | Password                                    | Role/Access                         |  Services                     |
|:-------------------:|:------------------------------------------:| :---------------------------------: |:-----------------------------:|
| iudx_rs_user       | secrets/passwords/postgres-rs-password       | SELECT,INSERT,DELETE,UPDATE on tables of ```iudx_rs``` Database   | Used by resource server      |
| iudx_keycloak_user | secrets/passwords/postgres-keycloak-password |  Owner of ```iudx_keycloak``` database                   | Used by keycloak server      |
| iudx_auth_user     |   secrets/passwords/postgres-auth-password   |   Access given while setting up auth server             | Used by auth server          |
| postgres           | secrets/passwords/postgresql-password     |     Superuser                                             |  Used to set users and RBAC  |
                            
5.  If you need to expose the psql server port or have custom stack configuration ( see [here](example-postgres-stack.custom.yaml) for example configuration of 'postgres-stack.custom.yaml' file)  and bring up like as follows
```sh
docker stack deploy -c postgres-stack.yaml -c postgres-stack.resources.yaml -c postgres-stack.custom.yaml postgres
```
