#!/bin/bash

BUCKET_NAME=$1
BACKUP_NAME=$2
OLD_ZONE=$3
NEW_ZONE=$4

mkdir $BACKUP_NAME-fix
cd $BACKUP_NAME-fix

# Volume snapshots
aws s3 cp s3://$BUCKET_NAME/backups/$BACKUP_NAME/$BACKUP_NAME-volumesnapshots.json.gz .
gunzip $BACKUP_NAME-volumesnapshots.json.gz
sed -i "s/$OLD_ZONE/$NEW_ZONE/g" $BACKUP_NAME-volumesnapshots.json
gzip $BACKUP_NAME-volumesnapshots.json
aws s3 cp $BACKUP_NAME-volumesnapshots.json.gz s3://$BUCKET_NAME/backups/$BACKUP_NAME/$BACKUP_NAME-volumesnapshots.json.gz

# PV manifests
aws s3 cp s3://$BUCKET_NAME/backups/$BACKUP_NAME/$BACKUP_NAME.tar.gz .
mkdir $BACKUP_NAME-temp
tar -xvf $BACKUP_NAME.tar.gz -C $BACKUP_NAME-temp
cd $BACKUP_NAME-temp
find . -name \*.json -exec sh -c "sed -i 's/$OLD_ZONE/$NEW_ZONE/g' {}" \;
tar czf ../$BACKUP_NAME.tar.gz *
aws s3 cp ../$BACKUP_NAME.tar.gz s3://$BUCKET_NAME/backups/$BACKUP_NAME/$BACKUP_NAME.tar.gz
