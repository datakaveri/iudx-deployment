# Install

## Required secrets
```sh
secrets/
|-- files
|   `-- pg-dump.sql
|-- passwords
|   |-- auth-cred-db-passwd
|   |-- rabbitmq-admin-passwd
|   `-- rabbitmq-definitions.json
`-- pki
    |-- backup-ssh-privkey
    |-- backup-ssh-pubkey
    |-- rabbitmq-ca-cert.pem  (letsencrpt chain.pem)
    |-- rabbitmq-server-cert.pem (letsencrpt fullchain.pem)
    `-- rabbitmq-server-key.pem (letsencrypt privkey.pem)
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

