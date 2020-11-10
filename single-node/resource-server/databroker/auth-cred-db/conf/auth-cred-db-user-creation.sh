#!/bin/bash

set -e
echo "$PWD"
export PASSWD=`cat /run/secrets/auth-cred-db-passwd`

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" -c "ALTER ROLE iudx_user WITH  ENCRYPTED PASSWORD '$PASSWD';"
