#!/bin/bash

keystore="./keystores"
passwords="./passwords"

kibana-keystore create

echo "kibana_system" | kibana-keystore add elasticsearch.username
(cat "$passwords/kibana-system-password"; echo) | kibana-keystore add elasticsearch.password

cp /usr/share/kibana/data/kibana.keystore "$keystore"
