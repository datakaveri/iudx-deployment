#!/bin/bash

set -e
echo "$PWD"
auth_cred_db_username=`cat /run/secrets/auth-cred-db-username`
auth_cred_db_passwd=`cat /run/secrets/auth-cred-db-passwd`
database_name=iudx
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname iudx <<-EOSQL
CREATE ROLE $auth_cred_db_username;
ALTER ROLE $auth_cred_db_username WITH NOSUPERUSER NOINHERIT NOCREATEROLE CREATEDB LOGIN NOREPLICATION BYPASSRLS;
ALTER ROLE $auth_cred_db_username WITH  ENCRYPTED PASSWORD '$auth_cred_db_passwd';
ALTER DATABASE $database_name OWNER TO $auth_cred_db_username;
ALTER TABLE public.databroker OWNER TO $auth_cred_db_username;
ALTER TABLE public.file_server_token OWNER TO $auth_cred_db_username;
ALTER TABLE public.registercallback OWNER TO $auth_cred_db_username;
DROP ROLE temp;
GRANT USAGE ON SCHEMA public TO $auth_cred_db_username;
EOSQL

