#!/bin/bash

keystore="/opt/bitnami/logstash/secrets/keystores"
passwords="/opt/bitnami/logstash/secrets/passwords"

echo "y" | logstash-keystore create 

cat "$passwords/logstash-rabbitmq-username" | logstash-keystore add rabbitmq_username
cat "$passwords/logstash-rabbitmq-password" | logstash-keystore add rabbitmq_password

echo "logstash-internal" | logstash-keystore add elasticsearch_username 
cat "$passwords/logstash-internal-password" | logstash-keystore add elasticsearch_password

cp /opt/bitnami/logstash/config/logstash.keystore "$keystore"
