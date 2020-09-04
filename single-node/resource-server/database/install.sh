#!/bin/bash
docker secret create  kibana_tls_cert.pem secrets/kibana_tls_cert.pem
docker secret create kibana_tls_key.pem secrets/kibana_tls_key.pem
docker stack deploy -c database_stack.yml database
