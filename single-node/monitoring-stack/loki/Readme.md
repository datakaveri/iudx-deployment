Initial setup:
docker volume create loki-volume

To build doocker :
```docker build -t <username>/loki:<tag> -f Dockerfile .```
 command to run
``` docker run  -d  --name Loki -v loki-volume:/data/loki -p 3100:3100 --user 0 --restart always <username>/loki:<tag> -config.file=/usr/share/loki-conf/loki-config.yaml```
