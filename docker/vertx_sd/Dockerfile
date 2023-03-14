FROM python:3-slim

WORKDIR /usr/share/app
COPY src src
RUN pip install --no-cache-dir src/

ENTRYPOINT ["vertx_sd"]
CMD ["--tick", "2","--dst", "/tmp/metrics-targets/vertx-targets.json","--hazelcast","--zoos", "zookeeper"]
