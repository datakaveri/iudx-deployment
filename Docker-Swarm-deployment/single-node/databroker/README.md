# Install
 Following deployments assume, there is a docker swarm and  docker overlay network called "overlay-net"  in the swarm. Please [refer](../../../docs/swarm-setup.md) to bring up docker swarm and the network.
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
Please see the example-secrets directory to get more idea, can use the 'secrets' in that directory by copying into cat directory i.e. cp -r example-secrets/secrets . for demo or local testing purpose only! For other environment, please generate strong passwords. For other environment, please generate strong passwords and a correct certificate instead of self signed certificate. For example using [letsencrypt](https://certbot.eff.org/lets-encrypt/ubuntufocal-other) to generate a proper certificate

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
Two ways to deploy 
1. Quick deploy
```sh
# rabbitmq not exposed + backup
docker stack deploy -c databroker-stack.yaml  databroker
```
2. You can add more custom stack cofiguration in file 'databroker-stack.custom.yaml' that overrides base 'databroker-stack.yaml' file like ports mapping etc ( see [here](example-databroker-stack.custom.yaml) for example configuration of 'databroker-stack.custom.yaml' file) and bring up like as follows. It is suitable for trying out locally,dev, staging and testing environment where some custom configuration such as host port mapping is needed.

```sh
# rabbitmq at random port + backup 
docker stack deploy -c databroker-stack.yaml -c databroker-stack.custom.yaml  databroker
```
