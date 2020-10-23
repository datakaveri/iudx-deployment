# Install

## Required secrets
```sh
secrets/
|-- config
|   |-- auth-cred-db-schema.sql
|   `-- auth-cred-db-user.sh
|-- files
|   `-- pg_dump_data.sql
|-- passwords
|   |-- auth-cred-db-passwd
|   |-- postgres-super-user-passwd
|   |-- rabbitmq-admin-passwd
|   `-- rabbitmq-definitions.json
`-- pki
    |-- backup-ssh-privkey
    |-- backup-ssh-pubkey
    |-- rabbitmq-ca-cert.pem
    |-- rabbitmq-server-cert.pem
    `-- rabbitmq-server-key.pem

```
## Assign node labels
docker node update --label-add databroker_node=true <node_name>
docker node update --label-add auth_cred_db_node=true <node_name>

## Assign back-up machine
Assign  backup machine ip/domain to remote_machine env variable in  .prod or .test or .dev stack
files depending on type of deployment

## Create backup directory
create backup directory "/root/rabbitmq-backup" in backup machine.

## Deploy

### Production
docker stack deploy -c databroker-stack.yml -c databroker-stack.prod.yml  databroker
### Testing
docker stack deploy -c databroker-stack.yml -c databroker-stack.test.yml  databroker
### Development
docker stack deploy -c databroker-stack.yml -c databroker-stack.dev.yml  databroker

