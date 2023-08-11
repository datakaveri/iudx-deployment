# Introduction
Docker swarm stack for IUDX Consent-Validation Deployment

# Installation of Consent Validation
## Create secret files
1. Make a copy of sample secrets directory.

```console
 cp -r example-secrets/secrets .
```
2. Substitute appropriate values using commands whatever mentioned in config files. Configure the secrets/.consent.env file with appropriate values 
3. Generate a keystore  for JWT signing using following command:
    ```sh
    keytool -genkeypair -keystore secrets/keystore.jks -storetype jks -storepass  <keystore-password> -keyalg EC -alias ES256 -keypass <keystore-password>  -sigalg SHA256withECDSA -dname "CN=,OU=,O=,L=,ST=,C=" -validity 360 -deststoretype pkcs12
    ```sh
4. Secrets directory after generation of secret files
secrets/
├── config.json
└── .consent.env
└── keystore.jks 


## Assign node labels
 
The consent container is constrained to run on specifc node by adding node labels to only one of the nodes, refer [here](https://docs.docker.com/engine/swarm/services/#placement-constraints) for more info. This ensures the container is placed always to same node on restart.
```sh
docker node update --label-add consent-node=true <node_name>
```

## Define Appropriate values of resources

Define Appropriate values of resources -
- CPU of rs-server 
- RAM of rs-server
- PID limit of rs-server
in `consent-stack.resources.yaml` as shown in sample resource-values file for [here](example-consent-stack.resources.yaml)

## Deploy
Deploy consent server:
```sh
docker stack deploy -c consent-stack.yaml -c consent-stack.resources.yaml consent
```
The apis documentation will be available at https://<consent-server-domain-name>/apis
# NOTE
1. The upstream code for consent validation is available at [here](https://github.com/datakaveri/consent-manager).


