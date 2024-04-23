#!/bin/bash

#set -e

# create required secrets
echo -n  $(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 30) > secrets/passwords/postgresql-password
echo -n  $(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 30) > secrets/passwords/repmgr-password
echo -n  $(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 30) > secrets/passwords/postgres-auth-password
echo -n  $(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 30) > secrets/passwords/postgres-rs-password
echo -n  $(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 30) > secrets/passwords/postgres-keycloak-password
echo -n  $(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 30) > secrets/passwords/postgres-acl-apd-password
echo -n  $(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 30) > secrets/passwords/postgres-dmp-apd-password
echo -n "postgres;iudx_rs_user;iudx_auth_user;iudx_keycloak_user;iudx_acl_apd_user;iudx_dmp_apd_user" > secrets/passwords/usernames
echo -n "$(cat secrets/passwords/postgresql-password);$(cat secrets/passwords/postgres-rs-password);$(cat secrets/passwords/postgres-auth-password);$(cat secrets/passwords/postgres-keycloak-password);$(cat secrets/passwords/postgres-dmp-apd-password);$(cat secrets/passwords/postgres-acl-apd-password)" > secrets/passwords/passwords

