#!/bin/bash

echo -n  $(cat /dev/urandom | tr -dc 'a-zA-Z0-9-!@#$%^&*+|:<>?' | head -c 16) > secrets/admin-password
cp ../postgresql/secrets/passwords/postgres-keycloak-password   secrets/db-password
