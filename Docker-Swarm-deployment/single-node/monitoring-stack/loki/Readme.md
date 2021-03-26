# Loki 

## Build doocker image
```sh 
docker build -t <username>/loki:<tag> -f Dockerfile .
```
## RUN 
``` sh
docker run  -d  --net=<network> --name loki -v loki-volume:/data/loki -p 3100:3100 --user root  <username>/loki:<tag> -config.file=/usr/share/loki-conf/loki-config.yaml
```
## Description
