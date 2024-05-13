# Introduction
Docker swarm stack for Catalogue api server deployment.

# Installation of Catalogue api server
## Create secret files
1. Make a copy of sample secrets directory 
```console
 cp -r example-secrets/ .
```
2. Substitute appropriate values using commands whatever mentioned in config files. Configure the secrets/.cat.env file with appropriate values in the place holders “<>”.
3. Following config options are only need to be configured if its deployed as UAC catalogue, or else it can 
   be left as is :
```
      "keycloakServerHost": "https://{{keycloak-domain}}/auth/realms/demo",
      "certsEndpoint": "/protocol/openid-connect/certs"
``` 
4. Secrets directory after generation of secret files
```sh
secrets/
├── .cat.env
└── config.json
└── profanity-config
        └── config.json

```
## Assign node labels
 The cat container is constrained to run on specifc node by adding node labels to only one of the nodes, refer [here](https://docs.docker.com/engine/swarm/services/#placement-constraints) for more info. This ensures the container is placed always to same node on restart.
```sh
docker node update --label-add cat-node=true <node_name>
```
## Define Appropriate values of resources

Define Appropriate values of resources -
- CPU 
- RAM 
- PID limit 
in `cat-stack.resources.yaml` for cat server as shown in sample resource-values stack file for [here](example-cat-stack.resources.yaml)

## Deploy
Deploy Catalogue api server:
```sh
docker stack deploy -c cat-stack.yaml -c cat-stack.resources.yaml cat
```
The apis documentation will be available at https://<cat-api-server-domain-name>/apis
# NOTE
1. The upstream code for Catalogue Server pipeline is available [here](https://github.com/datakaveri/iudx-catalogue-server).
2. If you need to expose the HTTP ports or have custom stack configuration (see [here](example-cat-stack.custom.yaml) for example configuration of 'cat-stack.custom.yaml' file)  and bring up like as follows.
```sh
docker stack deploy -c cat-stack.yaml -c cat-stack.resources.yaml -c cat-stack.custom.yaml cat
```

## Deploy Profanity Check

Deploy Profanity Check Sdk:
```sh
docker stack deploy -c profanity-check-sdk.yaml  profanity-check 
```

