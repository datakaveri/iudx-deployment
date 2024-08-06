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

##acl-apd
acl_apd_username=iudx_acl_apd_user
acl_apd_passwd=$(cat /opt/bitnami/postgresql/secrets/postgres-acl-apd-password)
acl_apd_db_name=iudx_acl_apd

## dmp-apd
dmp_apd_username=iudx_dmp_apd_user
dmp_apd_passwd=$(cat /opt/bitnami/postgresql/secrets/postgres-dmp-apd-password)
dmp_apd_db_name=iudx_dmp_apd

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

PGPASSWORD=$(cat /opt/bitnami/postgresql/secrets/postgresql-password) psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER"  <<-EOSQL
CREATE ROLE $acl_apd_username WITH NOSUPERUSER NOINHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS;
ALTER ROLE $acl_apd_username WITH  ENCRYPTED PASSWORD '$acl_apd_passwd';
CREATE DATABASE $acl_apd_db_name WITH ENCODING 'UTF8';
ALTER DATABASE $acl_apd_db_name OWNER TO $acl_apd_username;
EOSQL

PGPASSWORD=$(cat /opt/bitnami/postgresql/secrets/postgresql-password) psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER"  <<-EOSQL
CREATE ROLE $dmp_apd_username WITH NOSUPERUSER NOINHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS;
ALTER ROLE $dmp_apd_username WITH  ENCRYPTED PASSWORD '$dmp_apd_passwd';
CREATE DATABASE $dmp_apd_db_name WITH ENCODING 'UTF8';
ALTER DATABASE $dmp_apd_db_name OWNER TO $dmp_apd_username;
EOSQL