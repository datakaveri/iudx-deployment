#!/bin/bash
# logstash-keystore used to store sensitive credentials needed 
#in pipeline configs (/usr/share/logstash/pipeline/*) or 
#logstash.yml in 'logstash.keystore' file

# if secrets directory doesn't exist
mkdir /root/secrets/  

echo "y" | logstash-keystore  --path.settings  /root/secrets create 
rabbitmq_user=""
rabbitmq_passwd=""
echo  "$rabbitmq_user" | logstash-keystore  --path.settings  /root/secrets add rabbitmq_user
echo  "$rabbitmq_passwd" | logstash-keystore  --path.settings  /root/secrets add rabbitmq_passwd
