#!/bin/bash

mkdir -p secrets/keystores
sudo chown -R 1000:0 secrets/keystores

docker run \
    --rm -it \
    -u 1000:0 \
    -v $(pwd)/keystore-generators/kibana.sh:/opt/bitnami/kibana/bin/run.sh \
    -v $(pwd)/secrets:/opt/bitnami/kibana/secrets \
    docker.io/bitnami/kibana:8.17.3-debian-12-r1 /opt/bitnami/kibana/bin/run.sh

docker run \
    --rm -it \
    -u 1000:0 \
    -v $(pwd)/keystore-generators/logstash.sh:/opt/bitnami/logstash/bin/run.sh \
    -v $(pwd)/secrets:/opt/bitnami/logstash/secrets \
    docker.io/bitnami/logstash:8.17.3-debian-12-r1 ./bin/run.sh

#sudo chown -R 1000:0 secrets/keystores
