#!/bin/bash

set -e
echo "$PWD"
rs_username=iudx_rs_user
rs_passwd=$(cat /opt/bitnami/postgresql/secrets/postgres-rs-password)
rs_db_name=iudx_rs
keycloak_username=iudx_keycloak_user
keycloak_passwd=$(cat /opt/bitnami/postgresql/secrets/postgres-keycloak-password)
keycloak_db_name=iudx_keycloak
auth_username=iudx_auth_user
auth_passwd=$(cat /opt/bitnami/postgresql/secrets/postgres-auth-password)
##auth server uses default postgres db 

PGPASSWORD=$(cat /opt/bitnami/postgresql/secrets/postgresql-password) psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
CREATE DATABASE $rs_db_name WITH ENCODING 'UTF8';
CREATE ROLE $rs_username WITH NOSUPERUSER NOINHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS;
ALTER ROLE $rs_username WITH  ENCRYPTED PASSWORD '$rs_passwd';
GRANT ALL ON SCHEMA public TO $rs_username;
EOSQL

PGPASSWORD=$(cat /opt/bitnami/postgresql/secrets/postgresql-password) psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER"  <<-EOSQL
CREATE ROLE $keycloak_username WITH NOSUPERUSER NOINHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS;
ALTER ROLE $keycloak_username WITH  ENCRYPTED PASSWORD '$keycloak_passwd';
CREATE DATABASE $keycloak_db_name WITH ENCODING 'UTF8';
ALTER DATABASE $keycloak_db_name OWNER TO $keycloak_username;

CREATE ROLE $auth_username WITH NOSUPERUSER NOINHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS;
ALTER ROLE $auth_username WITH  ENCRYPTED PASSWORD '$auth_passwd';
EOSQL
