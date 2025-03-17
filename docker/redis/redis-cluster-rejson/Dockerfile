FROM redislabs/rejson:2.8.4 as rejson
FROM docker.io/bitnami/redis-cluster:7.4.2
COPY --from=rejson /usr/lib/redis/modules/rejson.so /usr/local/lib/rejson.so
WORKDIR /opt/bitnami
