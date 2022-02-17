# Installation
This installs a  keycloak HA with autoscaling based cpu load enabled with iudx custom themes.
The helm chart is based on bitnami : https://github.com/bitnami/charts/tree/master/bitnami/keycloak

## Build docker image
```
docker build -t <dockerhub-url>/<repo-name>/keycloak:14.0.0 -f docker/Dockerfile  docker/
```
## Create Sealed secrets
0. Generate sealed secret for docker registry login if not generated, see [here](../K8s-cluster/sealed-secrets/README.md) and keycloak-db password in postgesql ```../postgresql/secrets/postgres-keycloak-password ```.
1. Generate required secrets and create sealed secrets using follwing command:
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

# sealed-secrets
sealed-secrets/
├── keycloak-env-secret.yaml
└── keycloak-passwords.yaml

```

## Define Appropriate values of resources

Define Appropriate values of resources -
- CPU of keycloak
- RAM of keycloak
in resource-values.yaml as shown below:

```
resources:
  limits:
    cpu: 1800m
    memory: 1.8Gi
  requests:
    cpu: 500m
    memory: 256Mi

```

## Deploy

```
./install.sh --set ingress.hostname=<domain-name>
```

Following script will create :
1. create a namespace keycloak
2. create corresponding K8s secrets from sealed secrets
3. create required configmaps
4. create a keycloak cluster

# Note
## Upgradation
```
KEYCLOAK_ADMIN_PASSWORD=$(kubectl get secret --namespace keycloak keycloak-passwords -o jsonpath="{.data.admin-password}" | base64 --decode)
KEYCLOAK_MANAGEMENT_PASSWORD=$(kubectl get secret --namespace keycloak keycloak-passwords -o jsonpath="{.data.management-password}" | base64 --decode)

helm upgrade keycloak -n keycloak  bitnami/keycloak \
    --set auth.adminPassword=KEYCLOAK_ADMIN_PASSWORD \
    --set auth.managementPassword=KEYCLOAK_MANAGEMENT_PASSWORD 
```
