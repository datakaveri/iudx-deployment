#!/bin/bash
mkdir -p secrets/passwords
echo -n  $(cat /dev/urandom | tr -dc 'a-zA-Z0-9-!@#$%^&*+|:<>?' | head -c 16) > secrets/passwords/keycloak-admin-passwd
cp ../postgres/secrets/passwords/postgres-keycloak-password  secrets/passwords/keycloak-db-passwd
