
# PostgreSQL pg_upgrade for Kuberentes

This document outlines the steps involved in upgrading PostgreSQL from version 16 to 17 using `pg_upgrade`. This upgrade also involves using a custom Docker image to fix permissions and ensure the necessary packages are available during the upgrade.

## 1. Introduction to `pg_upgrade`

`pg_upgrade` is a utility that allows you to upgrade PostgreSQL from an old version to a new version by transferring the database data without needing to dump and restore the data. It is faster than traditional methods and preserves the existing database configuration and data while upgrading the binaries.

In this example, we are upgrading PostgreSQL from version 16 to version 17. The following steps outline how to use `pg_upgrade` to perform the upgrade while ensuring that the necessary configurations and roles are maintained.



## 2. `pg_upgrade` Pre-requisites

The following files are required and can be located in the PostgreSQL 16 container. Copy the files from your PostgreSQL 16 container and have them locally before starting the upgrade:

- **postgresql.conf: /bitnami/postgresql/data/postgresql.conf**
- **pg_hba.conf: /bitnami/postgresql/data/pg_hba.conf**
- **conf.d: /bitnami/postgresql/data/conf.d**
- **PostgreSQL 16 binaries: /opt/bitnami/postgresql/bin/**

Before proceeding with the upgrade, take a Velero backup of the PostgreSQL cluster:
```bash
velero create backup psql-manual-backup --from-schedule psql-daily-backup
```




## 3. Volume Preparation

Before upgrading, identify the primary pod in the postgres namespace and find the PersistentVolume (PV) associated with its PVC. Modify the PV to set the persistentVolumeReclaimPolicy to Retain using the following steps:

Edit the PV using kubectl edit pv <pv-name>

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


## 4. Prepare a Custom Dockerfile for PostgreSQL 17

Create a custom Dockerfile to install necessary PostgreSQL 16 binaries required for pg_upgrade: ( Dockerfile has already been located at iudx-deployment/docker/postgres/pg_upgrade/k8s)

1. Mount the PVC created above as /bitnami/postgres16 in the PostgreSQL 17 helmchart and deploy PostgreSQL 17 with the latest Bitnami Helm chart in the postgres namespace with 1 replica.

2. Verify that the repmgr role and database are created.

**Note :** The packages installed in this Dockerfile are required by PostgreSQL 16 and are used for the pg_upgrade process. For future upgrades, modify the Dockerfile to match the version-specific dependencies.


## 5. Backup the `repmgr` Database

- Dump the repmgr database using the below commnad and store it in local:
 
```bash
pg_dump -U repmgr -d repmgr -Fc -f /tmp/repmgr.dump
```
- Take a backup of the repmgr folder located at `/opt/bitnami/repmgr`.

## 6. Redeploy PostgreSQL17 

- Reploy PostgreSQL 17 Helm chart with sleep infinity as the startup command so the container stays idle for upgrade preparation

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



## 11. Update Collation Version for Each Database

After the upgrade, update the collation version for each database:

1. **Run the script** to reindex and refresh the collation version:
    ```bash
    #!/bin/bash

    DBS=$(psql -U postgres -At -c "SELECT datname FROM pg_database WHERE datistemplate = false AND datallowconn = true;")

    for DB in $DBS; do
      echo "Reindexing $DB..."
      psql -U postgres -d "$DB" -c "REINDEX DATABASE $DB;"
      psql -U postgres -d "$DB" -c "ALTER DATABASE $DB REFRESH COLLATION VERSION;"
    done
    ```

2. **For `template1` database**, do it manually:
    ```bash
    reindex database template1
    ALTER DATABASE template1 REFRESH COLLATION VERSION;
    ```
3. To verify that the collation versions are updated correctly, run the following query:

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
    ```sql
    \c repgmr
    \dx
    ALTER EXTENSION repmgr UPDATE;
    ```

3. **Restore the `repmgr` dump** and repository folder to `/opt/bitnami/`.

    ```bash
    kubectl cp ./repmgr.dump postgres/psql-postgresql-ha-postgresql-0:/tmp/repmgr.dump
    kubectl cp ./repmgr postgres/psql-postgresql-ha-postgresql-0:/opt/bitnami/repmgr
    ```

    ```bash
    pg_restore -U repmgr -d repmgr -Fc /tmp/repmgr.dump
    ```




## 13. Remove `postmaster.pid` File

Remove the `postmaster.pid` file to allow PostgreSQL to start:

```bash
rm /bitnami/postgresql/data/postmaster.pid
```



## 14. Redeploy the Helm Chart

1. **Redeploy the PostgreSQL Helm chart** without the `sleep infinity` command to start PostgreSQL.

2. **Verify the replica** and check if it's syncing properly with the primary.

3. **Scale up the replicas** once everything is verified, and check logs for errors.



## 15. Final Check

Once the upgrade is complete, verify that the PostgreSQL 17 cluster is functioning correctly, and confirm that the replica is syncing correctly with the primary.

If everything is working fine, redeploy the Helm chart with the official Bitnami `postgresql-repmgr` image.