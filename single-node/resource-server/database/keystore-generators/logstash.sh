#!/bin/bash

keystore="./keystores"
passwords="./passwords"

echo "y" | logstash-keystore create 

cat "$passwords/logstash-rabbitmq-username" | logstash-keystore add rabbitmq_username
cat "$passwords/logstash-rabbitmq-password" | logstash-keystore add rabbitmq_password

cat "$passwords/logstash-internal-username" | logstash-keystore add elasticsearch_username 
cat "$passwords/logstash-internal-password" | logstash-keystore add elasticsearch_password

cp /usr/share/logstash/config/logstash.keystore "$keystore"