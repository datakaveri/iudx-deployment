# Introduction
Docker swarm stack for Rabbitmq Deployment.
# Rabbitmq Installation
## Create secret files
1. Make a copy of sample secrets directory.
```console
 cp -r example-secrets/secrets .
```
2. To generate the passwords:
```console
./create-secrets.sh
```
3. Re-use the certficates generated during [nginx install](../nginx/README.md#create-secret-files) for next step

4. Copy certificate files to secrets directory as shown below:

```
cp /etc/letsencrypt/live/<domain-name>/chain.pem  secrets/pki/rabbitmq-ca-cert.pem

cp /etc/letsencrypt/live/<domain-name>/fullchain.pem  secrets/pki/rabbitmq-server-cert.pem

cp /etc/letsencrypt/live/<domain-name>/privkey.pem secrets/pki/rabbitmq-server-key.pem
```
5. If required, edit the config - ``secrets/init-config.json`` to suit the needs 
for users, exchanges, queues, bindings and policies.
### Configuring backup
Application at backup/backup-app backs up Rabbitmq definitions files to another VM using scp command whenever there is change in queues, users, exchanges.
* Need to generate dedicated ssh keys to use for scp to backup VM. Copy the private and public keys to ``secrets/pki/backup-ssh-privkey`` and ``secrets/pki/backup-ssh-pubkey``.
* Configure the secrets/.rabbitmq-backup.env file with appropriate values in the place holders “<>”.

Secrets directory after generation of secrets
```sh
secrets/
├── .rabbitmq.env
├── init-config.json
├── passwords
│   ├── admin-password
│   ├── auditing-password
│   ├── cat-password
│   ├── di-password
│   ├── fs-password
│   ├── gis-password
│   ├── lip-password
│   ├── logstash-password
│   ├── profanity-cat-password
│   ├── rs-password
│   ├── rs-proxy-adapter-password
│   └── rs-proxy-password
└── pki
    ├── rabbitmq-ca-cert.pem
    ├── rabbitmq-server-cert.pem
    └── rabbitmq-server-key.pem
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
RabbitMQ UI can be accessed from ``https://<rmq-hostname>:28041/``
## RMQ  vhosts, users, exchanges, queues, policies creation
1. Bring up the account generator stack (clean deployment or whenever any change in init-config)
```sh
docker stack deploy -c rmq-init-setup.yaml  rmq-tmp
```
2. Monitor logs to ensure creation
```sh
docker service logs rmq-tmp_rmq-init-setup -f
```
3. Remove stack, once vhosts, users, exchanges, queues, policies are created
```sh
docker stack rm rmq-tmp
```

# NOTE
1. If you need to expose the HTTP,AMQP ports or have custom stack configuration( see [here](example-databroker-stack.custom.yaml) for example configuration of 'databroker-stack.custom.yaml' file)  and bring up like as follows.

```sh
docker stack deploy -c databroker-stack.yaml -c databroker-stack.resources.yaml -c databroker-stack.custom.yaml databroker
```
This is generally useful in local, dev/test environment.
