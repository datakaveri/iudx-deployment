#!/bin/bash

mkdir -p secrets/keystores
sudo chown -R 1000:0 secrets/keystores

docker run \
    --rm -it \
    -u 1000:0 \
    -v $(pwd)/keystore-generators/elasticsearch.sh:/usr/share/elasticsearch/run.sh \
    -v $(pwd)/secrets:/usr/share/elasticsearch/secrets \
    docker.elastic.co/elasticsearch/elasticsearch:7.12.1 ./run.sh

docker run \
    --rm -it \
    -u 1000:0 \
    -v $(pwd)/keystore-generators/kibana.sh:/usr/share/kibana/run.sh \
    -v $(pwd)/secrets:/usr/share/kibana/secrets \
    docker.elastic.co/kibana/kibana:7.12.1 ./run.sh

docker run \
    --rm -it \
    -u 1000:0 \
    -v $(pwd)/keystore-generators/logstash.sh:/usr/share/logstash/run.sh \
    -v $(pwd)/secrets:/usr/share/logstash/secrets \
    docker.elastic.co/logstash/logstash:7.12.1 ./run.sh

#sudo chown -R 1000:0 secrets/keystores
