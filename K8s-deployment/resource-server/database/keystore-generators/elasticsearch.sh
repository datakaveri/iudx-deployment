#!/bin/bash

keystore="./secrets/keystores"
passwords="./secrets/passwords"
keys="./secrets/pki"

elasticsearch-keystore create --silent

cat "$passwords/elasticsearch-su-password" | elasticsearch-keystore add bootstrap.password
#cat "$keys/s3-access-key" | elasticsearch-keystore add s3.client.default.access_key
#cat "$keys/s3-secret-key" | elasticsearch-keystore add s3.client.default.secret_key

cp /usr/share/elasticsearch/config/elasticsearch.keystore "$keystore"
