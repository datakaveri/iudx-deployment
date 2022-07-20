#!/bin/bash

echo -n  $(cat /dev/urandom | tr -dc 'a-zA-Z0-9-!@#$%^&*+|:<>?' | head -c 16) > secrets/admin-password
echo -n  $(cat /dev/urandom | tr -dc 'a-zA-Z0-9-!@#$%^&*+|:<>?' | head -c 16) > secrets/management-password
cp ../postgresql/secrets/passwords/postgres-keycloak-password   secrets/database-password
echo -n  $(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 16) > secrets/admin-username
echo -n  $(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 16) > secrets/management-username
