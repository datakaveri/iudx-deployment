# Introduction
Docker swarm stack for Immudb Deployment.

# Immudb Installation
## Create secret files
1. Make a copy of sample secrets directory:

```console
cp -r example-secrets/secrets .
```
2. Properly configure env file immudb.env and audit.env file, this will be used for immudb-config-generator and immudb-audit

3. To generate the passwords:

```console
./create-secrets.sh
```
4. Secrets directory after generation of passwords:
```sh
secrets/
├── .config.env
└── passwords
    ├── admin-password
    ├── auth-password
    ├── cat-password
    └── rs-password
```
5. Disclaimer: check if all the passwords  contain upper and lower case letters, digits, punctuation mark or symbol. If not, regenerate the secrets using the script.

## Assign node labels
 The immudb container is constrained to run on specifc node by adding node labels to only one of the nodes, refer [here](https://docs.docker.com/engine/swarm/services/#placement-constraints) for more info. This ensures the container is placed always to same node on restart and able to mount the same local docker volume.
```sh
docker node update --label-add immudb-node=true <node_name>
```
## Define Appropriate values of resources

Define Appropriate values of resources -
- CPU 
- RAM 
- PID limit 
in `immudb-stack.resources.yaml`  for immudb as shown in sample resource-values file for [here](immudb-stack.resources.yaml)

## Deploy
Deploy immudb stack:
```sh
docker stack deploy -c immudb-stack.yaml -c immudb-stack.resources.yaml immudb
```
### Create users, schema required by api-servers 
Bring up the config and basic schema generator stack(only on clean deployment),
```sh
docker stack deploy -c immudb-config-generator.yaml tmp 

# Monitor logs to ensure creation
docker service logs tmp_immudbconfiggenerator -f

# Remove stack
docker stack rm tmp 
```
Please refer the note section to see in detail what dbs, and users are created and the code in docker/immudb-config-generator/immudb-config-generator.py

## Note
1.  The docker image 'ghcr.io/datakaveri/immudb-config-generator'  is tagged in accordance with immudb version used.
2. If you need to expose the immudb server ports, psql server port or have custom stack configuration( see [here](example-immudb-stack.custom.yaml) for example configuration of 'immudb-stack.custom.yaml' file)  and bring up like as follows.

```sh
docker stack deploy -c immudb-stack.yaml -c immudb-stack.resources.yaml -c immudb-stack.custom.yaml immudb
``` 
3.  Following users using the passwords present at files in ```secrets/passwords/``` directory and dbs are created accordingly using ``` docker/immudb-config-generator/immudb-config-generator.py``` script :

| Username           | Password                                    | Role/Access                         |  Services                     |
|:-------------------:|:------------------------------------------:| :---------------------------------: |:-----------------------------:|
| iudx_rs       | secrets/passwords/rs-password       | Read Write access to ```iudxrsorg``` Database   | Used by resource server  to audit to ```auditing``` table     |
| iudx_cat | secrets/passwords/cat-password |   Read Write access to ```iudxcat``` database                   | Used by catalogue server to audit to ```auditingtable``` table     |
| iudx_auth     |   secrets/passwords/auth-password   |   Read Write access to ```iudxauth``` database          | Used by auth server  to audit to ```table_auditing``` table        |
| immudb          | secrets/passwords/admin-password     |     Superuser                                            |  Used to create dbs, set users and RBAC  |
