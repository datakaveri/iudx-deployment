#!/bin/bash

keystore="./keystores"
passwords="./passwords"

elasticsearch-keystore create --silent

cat "$passwords/elasticsearch-su-password" | elasticsearch-keystore add bootstrap.password

cp /usr/share/elasticsearch/config/elasticsearch.keystore "$keystore"