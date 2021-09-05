#!/bin/bash

keystore="./secrets/keystores"
passwords="./secrets/passwords"

kibana-keystore create

echo "kibana_system" | kibana-keystore add elasticsearch.username
(cat "$passwords/kibana-system-password"; echo) | kibana-keystore add elasticsearch.password

cp /usr/share/kibana/data/kibana.keystore "$keystore"
# 7.12.1 creates keystore in path.config
cp /usr/share/kibana/config/kibana.keystore "$keystore"
