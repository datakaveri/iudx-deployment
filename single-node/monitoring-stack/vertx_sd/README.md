# Vert.x Instance Discovery
Discover Vert.x instances from Zookeeper and write to file watched by Prometheus.
## Build
```sh
docker build -t <username>/vertx_sd:latest -f Dockerfile .
```

## Run
```sh
docker run --net=<network> --rm -v /tmp/metrics-targets:/tmp/metrics-targets <username>/vertx_sd
```