# Installation
This installs a  keycloak HA with autoscaling based cpu load enabled with iudx custom themes.
The helm chart is based on bitnami : https://github.com/bitnami/charts/tree/master/bitnami/keycloak

## Docker image
Custom docker image ``ghcr.io/datakaveri/keycloak:26.2.3`` based on [bitnami keycloak image](https://hub.docker.com/r/bitnami/keycloak/) is used. The details are present at ../../Docker-Swarm-deployment/single-node/keycloak.

## Create Sealed secrets
0. Generate keycloak-db password in postgesql ```../postgresql/secrets/postgres-keycloak-password ```.
1. Generate other required secrets  using follwing command:
```
# command
./create_secrets.sh

# secrets directory after generation of secrets
secrets/
├── admin-password
├── admin-username
├── password (database password)
├── management-password
└── management-username
```

## Define Appropriate values of resources

Define Appropriate values of resources -
- CPU of keycloak
- RAM of keycloak
- ingress.hostname
- cert-manager issuer

in `resource-values.yaml` as shown in sample resource-values file for [`aws`](./example-aws-resource-values.yaml) and [`azure`](./example-azure-resource-values.yaml)

## Deploy

```
./install.sh
```

Following script will create :
1. create a namespace keycloak
2. create corresponding K8s secrets
3. create required configmaps
4. create a keycloak cluster

# Note
## Upgradation
```
KEYCLOAK_ADMIN_PASSWORD=$(kubectl get secret --namespace keycloak keycloak-passwords -o jsonpath="{.data.admin-password}" | base64 --decode)
KEYCLOAK_MANAGEMENT_PASSWORD=$(kubectl get secret --namespace keycloak keycloak-passwords -o jsonpath="{.data.management-password}" | base64 --decode)

helm upgrade   -f values.yaml -f resource-values.yaml  --set ingress.hostname=<domain-name> --set auth.adminPassword=KEYCLOAK_ADMIN_PASSWORD     --set auth.managementPassword=KEYCLOAK_MANAGEMENT_PASSWORD  keycloak  --version 24.5.6  bitnami/keycloak -n keycloak 
```
