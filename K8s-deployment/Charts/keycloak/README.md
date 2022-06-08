# Installation
This installs a  keycloak HA with autoscaling based cpu load enabled with iudx custom themes.
The helm chart is based on bitnami : https://github.com/bitnami/charts/tree/master/bitnami/keycloak

## Build docker image
Build and push the image to ghcr (if not present)
```
docker build -t ghcr.io/datakaveri/keycloak:14.0.0 -f docker/Dockerfile  docker/
```
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
├── database-password
├── management-password
└── management-username


```

## Define Appropriate values of resources

Define Appropriate values of resources -
- CPU of keycloak
- RAM of keycloak

in resource-values.yaml as shown in example-resource-values.yaml

## Deploy

```
./install.sh --set ingress.hostname=<domain-name>
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

helm upgrade   -f keycloak-values.yaml -f resource-values.yaml  --set ingress.hostname=<domain-name> --set auth.adminPassword=KEYCLOAK_ADMIN_PASSWORD     --set auth.managementPassword=KEYCLOAK_MANAGEMENT_PASSWORD  keycloak  --version 4.0.1 bitnami/keycloak -n keycloak 
```
