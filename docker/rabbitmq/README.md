# Rabbitmq backup
Docker image for rmq backup app

## Build Docker Image
```sh
docker build -t ghcr.io/datakaveri/rabbitmq-backup:1.0 -f backup/Dockerfile backup/
```

# Rabbitmq init scripts
Docker image for rmq init scripts

## Build Docker Image
```sh
docker build -t ghcr.io/datakaveri/rabbitmq-init:1.0 -f init-scripts/docker/Dockerfile .
```