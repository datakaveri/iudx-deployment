# Introduction
Docker swarm stack for Rabbitmq Deployment

# Rabbitmq Installation
## Create secret files
1. Make a copy of sample secrets directory.
```console
 cp -r example-secrets/secrets .
```
2. Re-use the certficates generated during [nginx install](../nginx/README.md#create-secret-files) for next step

3. Copy certificate files to secrets directory as shown below:

```
cp /etc/letsencrypt/live/<rabbitmq-fully-qualified-domain-name>/chain.pem  secrets/pki/rabbitmq-ca-cert.pem

cp /etc/letsencrypt/live/<rabbitmq-fully-qualified-domain-name>/fullchain.pem  secrets/pki/rabbitmq-server-cert.pem

cp /etc/letsencrypt/live/<rabbitmq-fully-qualified-domain-name>/privkey.pem secrets/pki/rabbitmq-server-key.pem
```
4.  Configure the secrets/.rabbitmq-backup.env file with appropriate values in the place holders “<>”

5. Secrets directory after generation of secrets
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
in `databroker-stack.resources.yaml`  for databroker as shown in sample resource-values file for [here](databroker-stack.resources.yaml)

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
