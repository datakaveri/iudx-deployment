# Prometheus
Configured to discover 
* Vert.x instances 
* Node exporters
* Docker daemons

## Update prometheus.yml config for monitoring minio

[Monitoring Minio with Prometheus Reference](https://min.io/docs/minio/linux/operations/monitoring/collect-minio-metrics-using-prometheus.html)


```sh 
vim conf/prometheus.yml
```

#### Generate minio Job with mc cli
 
1. To generate jwt for minio-job 

```bash 
mc admin prometheus generate ALIAS
```

NOTE: change ALIAS, It's the alias given when configuring the mc cli [For more infomation](https://min.io/docs/minio/linux/reference/minio-mc.html)

2. To generate jwt for minio-bucket-job 

```bash 
mc admin prometheus generate ALIAS bucket
```
NOTE: change ALIAS, It's the alias given when configuring the mc cli [For more infomation](https://min.io/docs/minio/linux/reference/minio-mc.html)

## Build
```sh
docker build -t <username>/prometheus:latest -f Dockerfile .
```

## Run
```sh
docker run --net=<network> --rm -p 9090:9090 -v /tmp/metrics-targets:/tmp/metrics-targets -v <data-volume>:/prometheus --user <docker-user> <username>/prometheus
```
Note: the owner of docker data-volume should be same as Prometheus user inside the container
