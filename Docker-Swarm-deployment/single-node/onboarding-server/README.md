# Introduction
Docker swarm stack for IUDX onboarding-server Deployment

# Installation of Onboarding server
## Create secret files
1. Make a copy of sample secrets directory.

```console
 cp -r example-secrets/secrets .
```
2. Substitute appropriate values using commands whatever mentioned in config files. Configure the secrets/.onboarding.env file with appropriate values in the place holders “<>”
3. Secrets directory after generation of secret files
```sh
secrets/
├── config.json
└── .onboarding.env
```
## Assign node labels
 The onboarding-server container is constrained to run on specifc node by adding node labels to only one of the nodes, refer [here](https://docs.docker.com/engine/swarm/services/#placement-constraints) for more info. This ensures the container is placed always to same node on restart.
```sh
docker node update --label-add onboarding-server-node=true <node_name>
```
## Define Appropriate values of resources

Define Appropriate values of resources -
- CPU 
- RAM 
- PID limit 
in `onboarding-server-stack.resources.yaml` as shown in sample resource-values file for [here](example-onboarding-server-stack.resources.yaml)

## Deploy
Deploy onboarding server stack:
```sh
docker stack deploy -c onboarding-server-stack.yaml -c onboarding-server-stack.resources.yaml onboarding-server
```
The apis documentation will be available at https://<onboarding-server-domain-name>/apis
# NOTE
1. The upstream code for onboarding server is available at [here](https://github.com/datakaveri/iudx-onboarding-server).
2. If you need to expose the HTTP ports or have custom stack configuration( see [here](example-onboarding-server-stack.custom.yaml) for example configuration of 'onboarding-stack.custom.yaml' file)  and bring up like as follows.
```sh
docker stack deploy -c onboarding-server-stack.yaml -c onboarding-server-stack.resources.yaml -c onboarding-server-stack.custom.yaml onboarding-server
```