# Introduction
Docker swarm stack for AAA/auth server Deployment.

# Installation of AAA/auth server
## Create secret files
1. Make a copy of sample secrets directory 
```console
 cp -r example-secrets/secrets .
```
2. Substitute appropriate values using commands whatever mentioned in config files. Configure the secrets/.aaa.env file with appropriate values in the place holders “<>”
3.  Generate a keystore  for JWT signing using following command:
```sh
keytool -genkeypair -keystore secrets/keystore.jks -storetype jks -storepass  <keystore-password> -keyalg EC -alias ES256 -keypass <keystore-password>  -sigalg SHA256withECDSA -dname "CN=,OU=,O=,L=,ST=,C=" -validity 360 -deststoretype pkcs12
```
For more information refer, [here](https://github.com/datakaveri/iudx-aaa-server#jwt-signing-key-setup).
4. Secrets directory after generation of secret files
```sh
secrets/
├── .aaa.env
├── config.json
└── keystore.jks
```

## Assign node labels
 The auth container is constrained to run on specifc node by adding node labels to only one of the nodes, refer [here](https://docs.docker.com/engine/swarm/services/#placement-constraints) for more info. This ensures the container is placed always to same node on restart.
```sh
docker node update --label-add auth-node=true <node_name>
```
## Define Appropriate values of resources

Define Appropriate values of resources -
- CPU 
- RAM 
- PID limit 
in `auth-stack.resources.yaml` for auth server as shown in sample resource-values stack file for [here](example-auth-stack.resources.yaml)

## Deploy
Deploy AAA/auth server:
```sh
docker stack deploy -c auth-stack.yaml -c auth-stack.resources.yaml auth
```

# NOTE
1. The upstream code for auth (aaa) server is available at https://github.com/datakaveri/iudx-aaa-server.
2. If you need to expose the HTTP ports or have custom stack configuration( see [here](example-auth-stack.custom.yaml) for example configuration of 'auth-stack.custom.yaml' file)  and bring up like as follows.
```sh
docker stack deploy -c auth-stack.yaml -c auth-stack.resources.yaml -c auth-stack.custom.yaml auth
```
