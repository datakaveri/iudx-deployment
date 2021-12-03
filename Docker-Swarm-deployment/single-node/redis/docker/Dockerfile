FROM redislabs/rejson:1.0.7 as rejson
FROM bitnami/redis:6.2.6 
COPY --from=rejson /usr/lib/redis/modules/rejson.so /usr/local/lib/rejson.so

