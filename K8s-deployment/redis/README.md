# Deployment Architecture
<p align="center">
<img src="./img/redis-cluster-topology.png">
</p>

This helm chart deploys a 6-node Redis Cluster with sharding, having 3 masters and 3 slaves.


# Installation
This installs a  Redis clustered setup.
The helm chart is based on bitnami : https://github.com/bitnami/charts/tree/master/bitnami/redis-cluster

## Create Custom Docker image
Creating custom image to include the [ReJSON module](https://github.com/RedisJSON/JRedisJSON)  on top of [bitnami redis-cluster docker image](https://github.com/bitnami/bitnami-docker-redis-cluster)

**Build docker image**
Redis-rejson image
```
docker build -t <registry-domain-name>/<repo-name>/redis-cluster-rejson:6.2.5-1.0.7 -f docker/redis-rejson/Dockerfile docker/redis-rejson
```
Redis-autoscaler image
```
docker build -t <registry-domain-name>/<repo-name>/redis-cluster-autoscaler:1.2 -f docker/redis-autoscaler/Dockerfile docker/redis-autoscaler
```
**Push docker image**
``
docker push <registry-domain-name>/<repo-name>/redis-cluster-rejson:6.2.5-1.0.7
```

## Create Sealed secrets
0. Generate sealed secret for docker registry login if not generated, see [here](../K8s-cluster/sealed-secrets/README.md) 
1. Generate required secrets and create sealed secrets using follwing script:

```
./create_secrets.sh
```
```
# secrets directory after generation of secrets
secrets/
└── redis-password

# sealed-secrets
sealed-secrets/
└── redis-passwords.yaml

```

## Define Appropriate values of resources

Define Appropriate values of resources -
- CPU of redis
- memory (RAM) of redis
- storage size and class 
in resource-values.yaml as shown below:

```
redis:
  resources:
    limits:
      cpu: 2000m
      memory: 4Gi
    requests:
      cpu: 250m
      memory: 200Mi

persistence:
  enabled: true
  path: /bitnami/redis/data
  subPath: ""
  storageClass: "ebs-storage-class"
  accessModes:
    - ReadWriteOnce
  size: 2Gi

```

## Deploy

```
./install.sh 
```

Following script will create :
1. create a namespace redis
2. create corresponding K8s secrets from sealed secrets
3. create a redis cluster

# Note
## Adding nodes to Redis Cluster

Following is example of addding two nodes to existing 6 nodes redis cluster
```
export REDIS_PASSWORD=$(kubectl get secret --namespace "redis" redis-passwords -o jsonpath="{.data.redis-password}" | base64 --decode)

helm upgrade --timeout 600s redis  --reuse-values --version 6.3.3  --set "password=${REDIS_PASSWORD},cluster.nodes=8,cluster.update.addNodes=true,cluster.update.currentNumberOfNodes=6" bitnami/redis-cluster -n redis 
```
### Rebalance the shards through redis-cli 

```
1. kubectl run --namespace redis redis-redis-cluster-client --rm --tty -i --restart='Never' \
 --env REDIS_PASSWORD=$REDIS_PASSWORD \
--image <registry-domian-name>/<repo-name>/redis-cluster-rejson:6.2.5-1.0.7 -- bash

2. redis-cli --cluster rebalance redis-redis-cluster:6379 --cluster-use-empty-masters -a $REDIS_PASSWORD

3. checking the rebalance: redis-cli --cluster check redis-redis-cluster:6379 -a $REDIS_PASSWORD

```
The adding of nodes results in creation of update job, which updates the cluster and restarts each pod one by one. The cluster will continue up while restarting pods one by one as the quorum is not lost.

## Backup and Restore using Velero
**Backing up redis-cluster**

```bash
velero backup create <backup-name> --include-resources=pvc,pv --selector app.kubernetes.io/name=redis-cluster
```

All backups created can be listed using:

```bash
velero backup get
```

To see more details about the backups:

```bash 
velero backup describe <backup-name> --details
```

**Restoring redis-cluster from backup**

```bash
velero restore create --from-backup <backup-name>
```

**Creating scheduled backups for redis**

Example: To create a backup every 6 hours with 24 hour retention period-

```bash
velero schedule create redis-backup --schedule "0 */6 * * *" --include-resources=pvc,pv --selector app.kubernetes.io/name=redis-cluster --ttl 24h    
```

This creates a backup object with the name redis-backup-\<TIMESTAMP\>.

