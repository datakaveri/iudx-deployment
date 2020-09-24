#!/bin/bash

mkdir -p secrets/keystores
chown -R 1000:0 secrets/keystores

docker run \
    --rm -it \
    -v $(pwd)/keystore-generators/elasticsearch.sh:/usr/share/elasticsearch/run.sh \
    -v $(pwd)/secrets/keystores:/usr/share/elasticsearch/keystores \
    -v $(pwd)/secrets/passwords:/usr/share/elasticsearch/passwords \
    docker.elastic.co/elasticsearch/elasticsearch:7.8.1 ./run.sh

docker run \
    --rm -it \
    -v $(pwd)/keystore-generators/kibana.sh:/usr/share/kibana/run.sh \
    -v $(pwd)/secrets/keystores:/usr/share/kibana/keystores \
    -v $(pwd)/secrets/passwords:/usr/share/kibana/passwords \
    docker.elastic.co/kibana/kibana:7.8.1 ./run.sh

docker run \
    --rm -it \
    -v $(pwd)/keystore-generators/logstash.sh:/usr/share/logstash/run.sh \
    -v $(pwd)/secrets/keystores:/usr/share/logstash/keystores \
    -v $(pwd)/secrets/passwords:/usr/share/logstash/passwords \
    docker.elastic.co/logstash/logstash:7.8.1 ./run.sh

sudo chown -R $USER:$USER secrets/keystores