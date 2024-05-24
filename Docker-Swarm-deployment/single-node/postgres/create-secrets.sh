#!/bin/bash

#set -e

# create required secrets
mkdir -p secrets/passwords
echo -n  $(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 30) > secrets/passwords/postgresql-password
echo -n  $(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 30) > secrets/passwords/postgres-auth-password
echo -n  $(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 30) > secrets/passwords/postgres-rs-password
echo -n  $(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 30) > secrets/passwords/postgres-keycloak-password
echo -n  $(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 30) > secrets/passwords/postgres-acl-apd-password
echo -n  $(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 30) > secrets/passwords/postgres-dmp-apd-password

