# Install
This install a 3 node zookeeper.
The helm chart is based on bitnami: https://github.com/bitnami/charts/tree/master/bitnami/zookeeper

## Define Appropriate values of resources
Define Appropiate resource values in ```resource-values.yaml```.
An example is given in example-resource-values.yaml.

## Deploy
1. Add bitnami repo and update
```
helm repo add bitnami https://charts.bitnami.com/bitnami && helm repo update
```
2. Create zookeeper namespace
```
kubectl create namespace zookeeper
```
3. Helm install zookeeper in zookeeper namespace
```
helm install -f zookeeper-values-yaml -f resource-values.yaml zookeeper --version 7.4.3  bitnami/zookeeper 
```

