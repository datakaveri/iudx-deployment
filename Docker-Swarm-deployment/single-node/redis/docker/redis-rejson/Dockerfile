FROM redislabs/rejson:2.0.9 as rejson
FROM bitnami/redis:7.0.2
COPY --from=rejson /usr/lib/redis/modules/rejson.so /usr/local/lib/rejson.so
WORKDIR /opt/bitnami
