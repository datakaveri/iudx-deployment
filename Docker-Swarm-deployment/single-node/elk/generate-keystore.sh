#!/bin/bash

mkdir -p secrets/keystores
sudo chown -R 1000:0 secrets/keystores

docker run \
    --rm -it \
    -v $(pwd)/keystore-generators/elasticsearch.sh:/usr/share/elasticsearch/run.sh \
    -v $(pwd)/secrets:/usr/share/elasticsearch/secrets \
    docker.elastic.co/elasticsearch/elasticsearch:8.3.3 ./run.sh

docker run \
    --rm -it \
    -v $(pwd)/keystore-generators/kibana.sh:/usr/share/kibana/run.sh \
    -v $(pwd)/secrets:/usr/share/kibana/secrets \
    docker.elastic.co/kibana/kibana:8.3.3 ./run.sh

docker run \
    --rm -it \
    -v $(pwd)/keystore-generators/logstash.sh:/usr/share/logstash/run.sh \
    -v $(pwd)/secrets:/usr/share/logstash/secrets \
    docker.elastic.co/logstash/logstash:8.3.3 ./run.sh

sudo chown -R 1000:0 secrets/keystores

