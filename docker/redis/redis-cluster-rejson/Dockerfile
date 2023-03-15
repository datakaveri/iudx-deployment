FROM redislabs/rejson:2.0.9 as rejson
FROM docker.io/bitnami/redis-cluster:7.0.2-debian-11-r8
COPY --from=rejson /usr/lib/redis/modules/rejson.so /usr/local/lib/rejson.so
WORKDIR /opt/bitnami
