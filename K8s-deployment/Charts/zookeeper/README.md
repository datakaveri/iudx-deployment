# Install
This install a 3 node zookeeper.
The helm chart is based on bitnami: https://github.com/bitnami/charts/tree/master/bitnami/zookeeper

## Define Appropriate values of resources
Define Appropriate values of resources -
- CPU of zookeeper
- RAM of zookeeper
- node-selector for zookeeper, to schedule the pods on particular type of node
- Disk storage size and storage class

in `resource-values.yaml` as shown in sample resource-values file for [`aws`](./example-aws-resource-values.yaml) and [`azure`](./example-azure-resource-values.yaml)

## Deploy

```
./install.sh
```
The script does following:
1. It adds bitnami helm repo
2. It creates zookeeper namespace
3. It installs HA 3 pod zookeeper cluster.
