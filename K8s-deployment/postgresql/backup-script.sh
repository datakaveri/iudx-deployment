#!/bin/sh

timestamp=$(date -I'seconds')

PGPASSWORD="$POSTGRES_PASSWORD" pg_dumpall -h psql-postgresql-ha-pgpool -p 5432 -U postgres | gzip | s3cmd -c /s3cmd/.s3cfg put - s3://$S3_BUCKET_NAME/psql-backups-$timestamp.sql.gz
echo "psql full backup taken successfully at $timestamp"
