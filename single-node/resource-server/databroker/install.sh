#!/bin/bash
docker secret create  rabbitmq_ca_cert.pem secrets/rabbitmq_ca_cert.pem
docker secret create rabbitmq_server_cert.pem secrets/rabbitmq_server_cert.pem
docker secret create rabbitmq_server_key.pem secrets/rabbitmq_server_key.pem
docker secret  create rabbitmq_definition.json secrets/rabbitmq_definition.json
docker stack deploy -c rabbitmq_stack.yml rabbitmq