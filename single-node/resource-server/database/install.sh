#!/bin/bash
docker secret create  kibana_tls_cert.pem secrets/kibana_tls_cert.pem
docker secret create kibana_tls_key.pem secrets/kibana_tls_key.pem
docker run -it --rm -v $PWD/:/root  docker.elastic.co/logstash/logstash:7.8.1 /bin/bash /root/logstash_setup.sh
docker secret create logstash_keystore secrets/logstash.keystore
docker stack deploy -c database_stack.yml database
