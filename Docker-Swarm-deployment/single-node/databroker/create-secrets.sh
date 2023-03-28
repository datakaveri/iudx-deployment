#!/bin/bash

echo -n  $(cat /dev/urandom | tr -dc 'a-zA-Z0-9-!@#$%^&*+|:<>?' | head -c 30) > secrets/passwords/admin-password
echo  "RABBITMQ_USERNAME=admin" > secrets/.rabbitmq.env
echo  "RABBITMQ_SECURE_PASSWORD=yes" >> secrets/.rabbitmq.env
echo  "RABBITMQ_PASSWORD=`cat secrets/passwords/admin-password`" >> secrets/.rabbitmq.env
echo -n  $(cat /dev/urandom | tr -dc 'a-zA-Z0-9-!@#$%^&*+|:<>?' | head -c 20) > secrets/passwords/rs-password
echo -n  $(cat /dev/urandom | tr -dc 'a-zA-Z0-9-!@#$%^&*+|:<>?' | head -c 20) > secrets/passwords/rs-proxy-password
echo -n  $(cat /dev/urandom | tr -dc 'a-zA-Z0-9-!@#$%^&*+|:<>?' | head -c 20) > secrets/passwords/rs-proxy-adapter-password
echo -n  $(cat /dev/urandom | tr -dc 'a-zA-Z0-9-!@#$%^&*+|:<>?' | head -c 20) > secrets/passwords/fs-password 
echo -n  $(cat /dev/urandom | tr -dc 'a-zA-Z0-9-!@#$%^&*+|:<>?' | head -c 20) > secrets/passwords/gis-password
echo -n  $(cat /dev/urandom | tr -dc 'a-zA-Z0-9-!@#$%^&*+|:<>?' | head -c 20) > secrets/passwords/di-password 
echo -n  $(cat /dev/urandom | tr -dc 'a-zA-Z0-9-!@#$%^&*+|:<>?' | head -c 20) > secrets/passwords/lip-password 
echo -n  $(cat /dev/urandom | tr -dc 'a-zA-Z0-9-!@#$%^&*+|:<>?' | head -c 20) > secrets/passwords/cat-password 
echo -n  $(cat /dev/urandom | tr -dc 'a-zA-Z0-9-!@#$%^&*+|:<>?' | head -c 20) > secrets/passwords/profanity-cat-password
echo -n  $(cat /dev/urandom | tr -dc 'a-zA-Z0-9-!@#$%^&*+|:<>?' | head -c 20) > secrets/passwords/logstash-password
echo -n  $(cat /dev/urandom | tr -dc 'a-zA-Z0-9-!@#$%^&*+|:<>?' | head -c 20) > secrets/passwords/auditing-password
