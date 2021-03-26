FROM python:3-slim

WORKDIR /usr/share/app
COPY vertx_sd vertx_sd
RUN pip install --no-cache-dir vertx_sd/

ENTRYPOINT ["vertx_sd"]
CMD ["--tick", "2","--dst", "/tmp/metrics-targets/vertx-targets.json","--hazelcast","--zoos", "zookeeper"]
