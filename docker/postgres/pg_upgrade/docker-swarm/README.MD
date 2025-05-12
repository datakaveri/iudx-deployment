# Pg_upgrade Docker-Swarm


## Dockerfile Overview

- **Modifications**:
  - Adds a new PostgreSQL user and modifies permissions.
  - Installs required libraries (`libssl1.1`, `libicu67`, `libldap`).
  - Uses `root` for administrative tasks, then switches back to PostgreSQL user (`1001`).


- **NOTE:** The packages installed in this Dockerfile are required by PostgreSQL 16 and are used for the pg_upgrade process. For future  upgrades, modify the Dockerfile to match the version-specific dependencies.  

## Build the Image

1. **Build the image**:
    ```bash
    docker build -t ghcr.io/datakaveri/postgresql-pg_upgrade-docker:17.4.0 .
    ```