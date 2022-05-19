FROM redislabs/rejson:1.0.7 as rejson
FROM docker.io/bitnami/redis-cluster:6.2.5-debian-10-r9
COPY --from=rejson /usr/lib/redis/modules/rejson.so /usr/local/lib/rejson.so
WORKDIR /opt/bitnami
