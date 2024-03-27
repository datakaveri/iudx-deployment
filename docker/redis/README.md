# Redis-Rejson 
Docker image for redis with rejson

## Build Docker Image
This builds custom docker image on top of [bitnami docker redis](https://github.com/bitnami/containers/tree/main/bitnami/redis) to include [rejson](https://redis.io/docs/stack/json/) module.
```sh
docker build -t ghcr.io/datakaveri/redis-rejson:7.2.4-2.6.8 -f redis-rejson/Dockerfile  redis-rejson/ 
```

# Redis autoscaler
Docker image for redis autoscaler

## Build Docker Image
```sh
docker build -t ghcr.io/datakaveri/redis-cluster-autoscaler:7.0.2 -f redis-autoscaler/Dockerfile redis-autoscaler/
```

# Redis-Rejson Cluster (For K8s)
Creating custom image to include the [ReJSON module](https://redis.io/docs/stack/json/)  on top of [bitnami redis-cluster docker image](https://github.com/bitnami/containers/tree/main/bitnami/redis-cluster).

## Build Docker Image
```sh
docker build -t ghcr.io/datakaveri/redis-cluster-rejson:7.0.2-2.0.9 -f redis-cluster-rejson/Dockerfile redis-cluster-rejson
```
