
# PostgreSQL pg_upgrade for Kuberentes

This document outlines the steps involved in upgrading PostgreSQL from version 16 to 17 using `pg_upgrade`.

## 1. Introduction to `pg_upgrade`

`pg_upgrade` is a utility that allows you to upgrade PostgreSQL from an old version to a new version by transferring the database data without needing to dump and restore the data. It is faster than traditional methods and preserves the existing database configuration and data while upgrading the binaries. The following steps outline how to use `pg_upgrade` to perform the upgrade while ensuring that the necessary configurations and roles are maintained.



## 2. `pg_upgrade` Pre-requisites

Before proceeding with the upgrade, take a Velero backup of the PostgreSQL cluster:
```bash
velero create backup psql-manual-backup --from-schedule psql-daily-backup
```

The following files are required and can be located in the PostgreSQL 16 container. First, identify the primary pod in the `postgres` namespace. Once identified, use the following commands to copy the necessary files from the PostgreSQL 16 container to your local machine:
:

- **postgresql.conf: /bitnami/postgresql/data/postgresql.conf**
- **pg_hba.conf: /bitnami/postgresql/data/pg_hba.conf**
- **conf.d: /bitnami/postgresql/data/conf.d**
- **PostgreSQL 16 binaries: /opt/bitnami/postgresql/bin/**

Use the following commands to copy these files from the PostgreSQL 16 container to your local machine:

```bash
kubectl cp -n postgres <pod>:/bitnami/postgresql/data/postgresql.conf ./postgresql.conf
kubectl cp -n postgres <pod>:/bitnami/postgresql/data/pg_hba.conf ./pg_hba.conf
kubectl cp -n postgres <pod>:/bitnami/postgresql/data/conf.d ./conf.d
kubectl cp -n postgres <pod>:/opt/bitnami/postgresql/bin ./postgresql16bin
```


## 3. Volume Preparation

Before upgrading, identify the primary pod in the postgres namespace and find the PersistentVolume (PV) associated with its PVC. Modify the PV to set the persistentVolumeReclaimPolicy to Retain using the following steps:

Edit the PV using 
```bash
kubectl edit pv <pv-name>
```

Change:
```bash
persistentVolumeReclaimPolicy: Delete
```
to:
```bash
persistentVolumeReclaimPolicy: Retain
```
* Delete all the PVCs in the postgres namespace.The retained PV will remain and can now be reused.

* Create a new PVC for this PV using a YAML manifest like below:
```bash
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: postgresql16-pvc
  namespace: postgres
spec:
  volumeName: <volume-name>
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 20Gi
  storageClassName: ebs-csi-storage-class  
```
*  ensure it is bounded and uninstall the postgres helm chart 
```bash
helm uninstall <release-name> -n postgres
```


## 4. Prepare a Custom Dockerfile for PostgreSQL 17

Create a custom Dockerfile to install necessary PostgreSQL 16 binaries required for pg_upgrade: ( Dockerfile has already been located at iudx-deployment/docker/postgres/pg_upgrade/k8s)

1. Use the custom PostgreSQL 17 image (which includes PostgreSQL 16 binaries) to deploy PostgreSQL 17 with 2 replicas using the Helm chart in the postgres namespace. Mount the previously created PVC at `/bitnami/postgres16` to make the old data directory accessible for the pg_upgrade process.

2. Verify that the repmgr role and database have been created successfully. Once verified, scale down the PostgreSQL cluster to 1 replica.

**Note :** The packages installed in this Dockerfile are required by PostgreSQL 16 and are used for the pg_upgrade process. For future upgrades, modify the Dockerfile to match the version-specific dependencies.


## 5. Backup the `repmgr` Database

- Before running `pg_upgrade`, back up the `repmgr` database and its associated configuration directory.

- Dump the `repmgr` Database from Inside the Container

1. **Access the primary PostgreSQL 17 container**:
  ```bash
   kubectl exec -it <pod-name> -n postgres -- bash  
   pg_dump -U repmgr -d repmgr -Fc -f /tmp/repmgr.dump
  ```
2. **The repmgr configuration are typically located in:**
- Take a backup of the repmgr folder located at `/opt/bitnami/repmgr`.

3. **Copy the Dump and Directory to Your Local Machine**

  ```bash
  kubectl cp postgres/<primary-pod-name>:/tmp/repmgr.dump ./repmgr.dump
  kubectl cp postgres/<primary-pod-name>:/opt/bitnami/repmgr ./repmgr
  ```

## 6. Redeploy PostgreSQL17 

- Reploy PostgreSQL 17 Helm chart with sleep infinity as the startup command so the container stays idle for upgrade process.

```bash
command:
  - "sleep"
  - "infinity"
```

## 7. Copy Necessary Files for `pg_upgrade`

`pg_upgrade` requires files like `postgresql.conf`, `pg_hba.conf`, and `config.d`. These files should be copied from PostgreSQL 16 to PostgreSQL 17:

1. **Copy necessary files** from PostgreSQL 16 to PostgreSQL 17:
    ```bash
    kubectl cp postgresql.conf psql-postgresql-ha-postgresql-0:/bitnami/postgres16/data/ -n postgres
    kubectl cp postgresql16bin psql-postgresql-ha-postgresql-0:/tmp/postgres16 -n postgres
    kubectl cp conf.d psql-postgresql-ha-postgresql-0:/bitnami/postgres16/data/conf.d -n postgres
    kubectl cp pg_hba.conf psql-postgresql-ha-postgresql-0:/bitnami/postgres16/data/pg_hba.conf -n postgres
    ```

## 8. Fix Permissions

Ensure proper file permissions:

```bash
chmod +x /tmp/postgres16/bin/postgres
chmod +x /tmp/postgres16/bin/pg_ctl
chmod +x /tmp/postgres16/bin/pg_controldata
chmod +x /tmp/postgres16/bin/pg_resetwal
chmod 700 /bitnami/postgres16/data
cd /tmp
```

## 9. Clean Target Location and Initialize PostgreSQL 17

`pg_upgrade` requires that the target directory be empty:

1. **Clean the target directory**:
    ```bash
    rm -rf /bitnami/postgresql/data/*
    ```

2. **Initialize PostgreSQL 17**:
    ```bash
    /opt/bitnami/postgresql/bin/initdb -D /bitnami/postgresql/data
    ```

## 10. Run `pg_upgrade`

Run `pg_upgrade` with the `--check` option for a dry run to verify everything is ready:

```bash
pg_upgrade -d /bitnami/postgres16/data -D /bitnami/postgresql/data -b /tmp/postgres16/bin -B /opt/bitnami/postgresql/bin --check
```

If everything is good, remove the `--check` flag and run `pg_upgrade` without it:

```bash
pg_upgrade -d /bitnami/postgres16/data -D /bitnami/postgresql/data -b /tmp/postgres16/bin -B /opt/bitnami/postgresql/bin
```

- Start PostgreSQL Manually...
```bash
pg_ctl start -D /bitnami/postgresql/data
```
After the upgrade, it's recommended to analyze all databases to help PostgreSQL optimize query planning. Run the following command inside the PostgreSQL 17 container:
```bash
/opt/bitnami/postgresql/bin/vacuumdb --all --analyze-in-stages
```

This command performs a staged ANALYZE on all databases to collect planner statistics.It ensures better performance of queries post-upgrade.


## 11.  Handle Collation Version Mismatches

After upgrading PostgreSQL, you may encounter errors related to collation version mismatch. To resolve this, run the following script to **reindex** all databases and **refresh their collation version**:

1. **Run the script** inside the postgresql 17 container :

    ```bash
    #!/bin/bash

    DBS=$(psql -U postgres -At -c "SELECT datname FROM pg_database WHERE datistemplate = false AND datallowconn = true;")

    for DB in $DBS; do
      echo "Reindexing $DB..."
      psql -U postgres -d "$DB" -c "REINDEX DATABASE $DB;"
      psql -U postgres -d "$DB" -c "ALTER DATABASE $DB REFRESH COLLATION VERSION;"
    done
    ```
> **Note:** The automated script will **not** update the collation version for `template1`. You must refresh `template1` manually by running the following commands: 

  ```bash
  REINDEX DATABASE template1;
  ALTER DATABASE template1 REFRESH COLLATION VERSION;
  ```

2. To verify that the collation versions are updated correctly, run the following query:

    ```bash
    SELECT datname, datcollversion FROM pg_database;
    ```



## 12. Restore `repmgr` Database and Files

1. **Restore the `repmgr` database** by dropping the old one and recreating it:
    ```sql
    DROP DATABASE repmgr;
    CREATE DATABASE repmgr OWNER repmgr;;
    ```

2. **Restore the `repmgr` extension**:

    After restoring the `repmgr` database from the backup, you need to **update the `repmgr` extension** to ensure it is compatible with the upgraded PostgreSQL version. Run the following SQL command:

    ```bash
    \c repgmr

    \dx  #to check the list of installed extension

    ALTER EXTENSION repmgr UPDATE;
    ```

3. **Restore the `repmgr` dump** and repository folder to `/opt/bitnami/`.

    ```bash
    kubectl cp ./repmgr.dump postgres/psql-postgresql-ha-postgresql-0:/tmp/repmgr.dump
    kubectl cp ./repmgr postgres/psql-postgresql-ha-postgresql-0:/opt/bitnami/repmgr
    ```

  To restore the `repmgr` tables from the backup dump, run the following command inside the PostgreSQL 17 container:
 
  ```bash
  pg_restore -U repmgr -d repmgr -Fc /tmp/repmgr.dump
  ```


## 13. Remove `postmaster.pid` File

Since PostgreSQL was started manually, a stale **`postmaster.pid`** file might prevent it from starting. To fix this, remove the file:

```bash
rm /bitnami/postgresql/data/postmaster.pid
```


## 14. Redeploy the Helm Chart

1. **Redeploy the PostgreSQL Helm chart** without the `sleep infinity` command to start PostgreSQL.

2. **Scale up the replicas** and check if they are syncing properly with the primary. After verification, check the logs for any errors.

3. If everything is working fine, redeploy the Helm chart with the official Bitnami `postgresql-repmgr` image.