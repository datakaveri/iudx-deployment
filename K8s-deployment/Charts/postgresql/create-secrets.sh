#!/bin/bash

#set -e

# create required secrets
echo -n  $(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 30) > secrets/passwords/postgresql-password
echo -n  $(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 30) > secrets/passwords/repmgr-password
echo -n  $(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 30) > secrets/passwords/postgres-auth-password
echo -n  $(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 30) > secrets/passwords/postgres-rs-password
echo -n  $(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 30) > secrets/passwords/postgres-keycloak-password
echo -n "postgre;postgres;iudx_rs_user;iudx_auth_user;iudx_keycloak_user" > secrets/passwords/usernames
cp secrets/passwords/postgresql-password secrets/passwords/password
echo -n "$(cat secrets/passwords/password);$(cat secrets/passwords/postgresql-password);$(cat secrets/passwords/postgres-rs-password);$(cat secrets/passwords/postgres-auth-password);$(cat secrets/passwords/postgres-keycloak-password)" > secrets/passwords/passwords

