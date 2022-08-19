# Introduction
Docker swarm stack for Rabbitmq Deployment.
# Rabbitmq Installation
##  Docker image
* Build Rabbitmq backup image 

```sh
docker build -f backup/Dockerfile -t ghcr.io/datakaveri/rabbitmq-backup:1.0 backup/
```
* Push Docker image 
```sh
docker push ghcr.io/datakaveri/rabbitmq-backup:1.0
```
## Create secret files
1. Make a copy of sample secrets directory.
```console
 cp -r example-secrets/secrets .
```
2. Re-use the certficates generated during [nginx install](../nginx/README.md#create-secret-files) for next step

3. Copy certificate files to secrets directory as shown below:

```
cp /etc/letsencrypt/live/<domain-name>/chain.pem  secrets/pki/rabbitmq-ca-cert.pem

cp /etc/letsencrypt/live/<domain-name>/fullchain.pem  secrets/pki/rabbitmq-server-cert.pem

cp /etc/letsencrypt/live/<domain-name>/privkey.pem secrets/pki/rabbitmq-server-key.pem
```
### Configuring backup
Application at backup/backup-app backs up Rabbitmq definitions files to another VM using scp command whenever there is change in queues, users, exchanges.
* Need to generate dedicated ssh keys to use for scp to backup VM. Copy the private and public keys to ``secrets/pki/backup-ssh-privkey`` and ``secrets/pki/backup-ssh-pubkey``.
* Configure the secrets/.rabbitmq-backup.env file with appropriate values in the place holders “<>”.

Secrets directory after generation of secrets
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

## Define Appropriate values of resources

Define Appropriate values of resources -
- CPU 
- RAM 
- PID limit 
in `databroker-stack.resources.yaml`  for databroker as shown in sample resource-values file for [here](example-databroker-stack.resources.yaml)

## Deploy
Deploy databroker stack:
```sh
docker stack deploy -c databroker-stack.yaml -c databroker-stack.resources.yaml databroker
```
RabbitMQ UI can be accessed from https://<rmq-hostname>:28041/
# NOTE
1. If you need to expose the HTTP,AMQP ports or have custom stack configuration( see [here](example-databroker-stack.custom.yaml) for example configuration of 'databroker-stack.custom.yaml' file)  and bring up like as follows.

```sh
docker stack deploy -c databroker-stack.yaml -c databroker-stack.resources.yaml -c databroker-stack.custom.yaml databroker
```
This is generally useful in local, dev/test environment.
