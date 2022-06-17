#!/bin/bash

set -e

# create required secrets
echo -n  $(cat /dev/urandom | tr -dc 'a-zA-Z0-9-!@#$%^&*+|:<>?' | head -c 16) > secrets/postgresql-password
echo -n  $(cat /dev/urandom | tr -dc 'a-zA-Z0-9-!@#$%^&*+|:<>?' | head -c 16) > secrets/repmgr-password
echo -n  $(cat /dev/urandom | tr -dc 'a-zA-Z0-9-!@#$%^&*+|:<>?' | head -c 16) > secrets/postgres-auth-password
echo -n  $(cat /dev/urandom | tr -dc 'a-zA-Z0-9-!@#$%^&*+|:<>?' | head -c 16) > secrets/postgres-rs-password
echo -n  $(cat /dev/urandom | tr -dc 'a-zA-Z0-9-!@#$%^&*+|:<>?' | head -c 16) > secrets/postgres-keycloak-password
echo -n "postgres;iudx_rs_user;iudx_auth_user;iudx_keycloak_user" > secrets/usernames
echo -n "$(cat secrets/postgresql-password);$(cat secrets/postgres-rs-password);$(cat secrets/postgres-auth-password);$(cat secrets/postgres-keycloak-password)" > secrets/passwords

