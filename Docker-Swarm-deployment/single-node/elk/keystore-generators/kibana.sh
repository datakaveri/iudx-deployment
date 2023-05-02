#!/bin/bash

keystore="/opt/bitnami/kibana/secrets/keystores"
passwords="/opt/bitnami/kibana/secrets/passwords"

kibana-keystore create

echo "kibana_system" | kibana-keystore add elasticsearch.username
(cat "$passwords/kibana-system-password"; echo) | kibana-keystore add elasticsearch.password

cp /opt/bitnami/kibana/config/kibana.keystore "$keystore"
