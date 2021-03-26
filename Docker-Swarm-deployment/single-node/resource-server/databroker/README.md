# Install

## Required secrets

```sh
secrets/
|-- passwords
|   |-- rabbitmq-admin-passwd
|   `-- rabbitmq-definitions.json
`-- pki
    |-- backup-ssh-privkey 
    |-- backup-ssh-pubkey
    |-- rabbitmq-ca-cert.pem   (letsencrpt chain.pem)
    |-- rabbitmq-server-cert.pem (letsencrpt fullchain.pem)
    `-- rabbitmq-server-key.pem  (letsencrypt privkey.pem)
```
## Assign node labels

```sh
docker node update --label-add databroker_node=true <node_name>
```
## Create .rabbitmq-backup.env file 
Assign env variables required for backup in .rabbitmq-backup.env file. Template
is shown below, the first two variables needs no change, the rest of it needs to
assigned appropiate values.

```sh
rabbitmq_url=https://rabbitmq:15671
rabbitmq_passwd_file=/run/secrets/rabbitmq-admin-passwd
# need to assign appropiate values to following fields
remote_machine=x.y.z.a						               #ip of remote machine
remote_user=xyz						                     	 #remote machine login user
rabbitmq_user=wyz						                     #rabbitmq username
remote_backup_dir=/home/rabbitmq-backup				   #backup directory path in remote machine
```
## Deploy

### Production
```sh
# rabbitmq at random port + backup
docker stack deploy -c databroker-stack.yml -c databroker-stack.prod.yml  databroker
```
### Testing
```sh
# rabbitmq at random port + backup 
docker stack deploy -c databroker-stack.yml -c databroker-stack.test.yml  databroker
```
### Development
```sh
# rabbitmq at 443 port
docker stack deploy -c databroker-stack.yml -c databroker-stack.dev.yml  databroker
```
