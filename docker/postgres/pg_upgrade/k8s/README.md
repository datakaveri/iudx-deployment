# PostgreSQL pg_upgrade for Kubernetes


## Purpose

This image is designed to support in-place PostgreSQL major version upgrades using `pg_upgrade` in a Kubernetes cluster, particularly when using the Bitnami PostgreSQL HA Helm chart.

> **Note:**  The packages installed in this Dockerfile are required by PostgreSQL 16 and are used for the pg_upgrade process. For future  upgrades, modify the Dockerfile to match the version-specific dependencies.  

## What It Does

- Adds missing legacy dependencies (`libssl1.1`, `libicu67`, and `libldap-2.4-2`) required by older PostgreSQL binaries.
- Creates a home directory for the `postgres` user to avoid issues when executing commands as a non-root user.
- Sets proper permissions on PostgreSQL and Repmgr directories for seamless access by UID 1001 (used by Bitnami containers).

## Build the Image

**Build the image**:

```bash
docker build -t ghcr.io/datakaveri/postgresql-pg_upgrade-repmgr:17.4.0 .
 ```




