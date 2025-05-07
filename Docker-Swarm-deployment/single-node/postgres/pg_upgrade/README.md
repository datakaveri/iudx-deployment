# PostgreSQL Upgrade using `pg_upgrade` in Docker Swarm

This guide outlines the steps to upgrade PostgreSQL from version 16 to 17 using `pg_upgrade` within a Docker Swarm environment.

`pg_upgrade` is a utility that allows you to upgrade PostgreSQL from an old version to a new version by transferring the database data without needing to dump and restore the data. It is faster than traditional methods and preserves the existing database configuration and data while upgrading the binaries.

### Requirments 

The following files are required and can be located in the PostgreSQL 16 container. Copy the files from your PostgreSQL 16 container and have them locally before starting the upgrade:

* postgresql.conf: /bitnami/postgresql/data/postgresql.conf

* pg_hba.conf: /bitnami/postgresql/data/pg_hba.conf

* conf.d: /bitnami/postgresql/data/conf.d

* PostgreSQL 16 binaries: /opt/bitnami/postgresql/bin/


---

##  Steps

### 1. Prepare a Custom Dockerfile for PostgreSQL 17

Create a custom Dockerfile to install necessary PostgreSQL 16 binaries required for `pg_upgrade`: ( Dockerfile has already been located at `iudx-deployment/docker/postgres/pg_upgrade/docker-swarm`)


> [!NOTE] 
> The packages installed in this Dockerfile are required by PostgreSQL 16 and are used for the pg_upgrade process. For future  upgrades, modify the Dockerfile to match the version-specific dependencies.



---

### 2. Start PostgreSQL 17 Container

To avoid permission issues and initialize the environment properly, start the PostgreSQL 17 container with the official Bitnami image:

```yaml
image: bitnami/postgresql:17.4.0
```

---

### 3. Clone the PostgreSQL 16 Data Volume

To perform the upgrade, you need a copy of the data from your PostgreSQL 16 instance. You can achieve this by creating a clone of the existing Docker volume.

Here’s how to clone the PostgreSQL 16 volume:

```bash
docker volume create --name cloned_pg16_data

# Replace <original_pg16_volume> with the name of your original volume
docker container create --name temp_pg16 -v <original_pg16_volume>:/from -v cloned_pg16_data:/to alpine

docker cp temp_pg16:/from/. /to/
docker rm temp_pg16
```

Then, mount this cloned volume into the PostgreSQL 17 container:

```yaml
volumes:
  - cloned_pg16_data:/bitnami/postgresql16
```

> Make sure `/bitnami/postgresql16/data` contains the cloned data from version 16.

---

### 4. Copy PostgreSQL 16 Binaries and Config Files

From the postgres16 container, copy the required files into the postgres17 container. You can find these files in the PostgreSQL 16 container at the following locations:

* PostgreSQL 16 binaries: /opt/bitnami/postgresql/bin/

* Configuration files: /bitnami/postgresql/data/

  postgresql.conf

  pg_hba.conf

  conf.d/

```bash
docker cp postgresql.conf <container_id>:/bitnami/postgresql16/data/
docker cp pg_hba.conf <container_id>:/bitnami/postgresql16/data/
docker cp conf.d <container_id>:/bitnami/postgresql16/data/conf.d
docker cp postgresql16bin <container_id>:/tmp/postgresql16
```

Ensure `conf.d` exists even if it's empty.

---

### 5. Set Correct Permissions

Inside the container, ensure PostgreSQL 16 binaries are executable:

```bash
chmod +x /tmp/postgresql16/bin/postgres
chmod +x /tmp/postgresql16/bin/pg_ctl
chmod +x /tmp/postgresql16/bin/pg_controldata
chmod +x /tmp/postgresql16/bin/pg_resetwal
```

  If facing permission issues, run the container as `root`.

---

### 6. Run `pg_upgrade` (Dry Run First)

Navigate to `/tmp` and run:

```bash
pg_upgrade \
  -d /bitnami/postgresql16/data \
  -D /bitnami/postgresql/data \
  -b /tmp/postgresql16/bin \
  -B /opt/bitnami/postgresql/bin \
  --check
```

If the dry run passes, rerun without `--check` to perform the actual upgrade:

```bash
pg_upgrade \
  -d /bitnami/postgresql16/data \
  -D /bitnami/postgresql/data \
  -b /tmp/postgresql16/bin \
  -B /opt/bitnami/postgresql/bin
```

---

### 7. Start PostgreSQL Manually

```bash
pg_ctl start -D /bitnami/postgresql/data
```


After the upgrade, it's recommended to analyze all databases to help PostgreSQL optimize query planning. Run the following command inside the PostgreSQL 17 container:

```bash
/opt/bitnami/postgresql/bin/vacuumdb --all --analyze-in-stages
```
This command performs a staged ANALYZE on all databases to collect planner statistics.

It ensures better performance of queries post-upgrade.

---

### 8. Restore PostgreSQL Roles

`pg_upgrade` does not migrate roles. Export them from the postgres16 and import into the postgres17 container:

```bash
# Export roles from old PostgreSQL 16 container
pg_dumpall --roles-only -U postgres > /tmp/pg_roles.sql

# Run the following command in the upgraded PostgreSQL 17 container
psql -U postgres -f /tmp/pg_roles.sql
```

---

### 9. Handle Collation Version Mismatches

If you encounter collation version mismatch errors, reindex and refresh collation versions:

**Manual Example:**

```sql
REINDEX DATABASE your_db_name;
ALTER DATABASE your_db_name REFRESH COLLATION VERSION;
```

**Automated Script:**

```bash
#!/bin/bash

DBS=$(psql -U postgres -At -c "SELECT datname FROM pg_database WHERE datistemplate = false AND datallowconn = true;")

for DB in $DBS; do
  echo "Reindexing $DB..."
  psql -U postgres -d "$DB" -c "REINDEX DATABASE $DB;"
  psql -U postgres -d "$DB" -c "ALTER DATABASE $DB REFRESH COLLATION VERSION;"
done
```

>  Note: The automated script will not update the collation version for `template1`. You must refresh `template1` manually:

```sql
REINDEX DATABASE template1;
ALTER DATABASE template1 REFRESH COLLATION VERSION;
```

To verify that the collation versions are updated correctly, run the following query:

```sql
SELECT datname, datcollversion FROM pg_database;
```

---

### 10. Cleanup and Finalize Deployment
 
Switch to Official Bitnami Image (Post-Upgrade)

 - After a successful upgrade, update your Docker Swarm configuration to use the standard Bitnami PostgreSQL 17 image.
   Once everything is validated and confirmed

- Remove the old PostgreSQL 16 stack from docker swarm and redeploy the PostgreSQL 17 stack with the original service name `postgres`.