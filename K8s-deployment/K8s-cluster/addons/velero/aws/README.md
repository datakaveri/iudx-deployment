## Setup

To set up Velero on AWS, you:

* [Create an S3 bucket]
* [Set permissions for Velero]
* [Install and start Velero]

## Create S3 bucket

Velero requires an object storage bucket to store backups in, preferably unique to a single Kubernetes cluster. Create an S3 bucket, replacing placeholders appropriately:

```bash
BUCKET=<YOUR_BUCKET>
REGION=<YOUR_REGION>
aws s3api create-bucket \
    --bucket $BUCKET \
    --region $REGION \
    --create-bucket-configuration LocationConstraint=$REGION
```
NOTE: us-east-1 does not support a `LocationConstraint`.  If your region is `us-east-1`, omit the bucket configuration:

```bash
aws s3api create-bucket \
    --bucket $BUCKET \
    --region us-east-1
```

## Set permissions for Velero

### Option 1: Set permissions with an IAM user

1. Create the IAM user:

    ```bash
    aws iam create-user --user-name velero
    ```

    If you'll be using Velero to backup multiple clusters with multiple S3 buckets, it may be desirable to create a unique username per cluster rather than the default `velero`.

2. Attach policies to give `velero` the necessary permissions:

    ```
    cat > velero-policy.json <<EOF
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Action": [
                    "ec2:DescribeVolumes",
                    "ec2:DescribeSnapshots",
                    "ec2:CreateTags",
                    "ec2:CreateVolume",
                    "ec2:CreateSnapshot",
                    "ec2:DeleteSnapshot"
                ],
                "Resource": "*"
            },
            {
                "Effect": "Allow",
                "Action": [
                    "s3:GetObject",
                    "s3:DeleteObject",
                    "s3:PutObject",
                    "s3:AbortMultipartUpload",
                    "s3:ListMultipartUploadParts"
                ],
                "Resource": [
                    "arn:aws:s3:::${BUCKET}/*"
                ]
            },
            {
                "Effect": "Allow",
                "Action": [
                    "s3:ListBucket"
                ],
                "Resource": [
                    "arn:aws:s3:::${BUCKET}"
                ]
            }
        ]
    }
    EOF
    ```
    ```bash
    aws iam put-user-policy \
      --user-name velero \
      --policy-name velero \
      --policy-document file://velero-policy.json
    ```

3. Create an access key for the user:

    ```bash
    aws iam create-access-key --user-name velero
    ```

    The result should look like:

    ```json
    {
      "AccessKey": {
            "UserName": "velero",
            "Status": "Active",
            "CreateDate": "2017-07-31T22:24:41.576Z",
            "SecretAccessKey": <AWS_SECRET_ACCESS_KEY>,
            "AccessKeyId": <AWS_ACCESS_KEY_ID>
      }
    }
    ```

4. Create a Velero-specific credentials file (`credentials-velero`) in your local directory:

    ```bash
    [default]
    aws_access_key_id=<AWS_ACCESS_KEY_ID>
    aws_secret_access_key=<AWS_SECRET_ACCESS_KEY>
    ```

    where the access key id and secret are the values returned from the `create-access-key` request.

## Install and start Velero

Install Velero, including all prerequisites, into the cluster and start the deployment. This will create a namespace called `velero`, and place a deployment named `velero` in it.

**If using IAM user and access key**:

```bash
velero install \
    --provider aws \
    --plugins velero/velero-plugin-for-aws:v1.5.0 \
    --bucket $BUCKET \
    --backup-location-config region=$REGION \
    --snapshot-location-config region=$REGION \
    --secret-file ./credentials-velero
```

## Backup
1. velero backup
```
velero backup create <backup-name> --include-resources=pvc,pv --selector <resource-label>
```
2. All backups created can be listed using:
```
velero backup get
```
3. To see more details about the backups:
```
velero backup describe <backup-name> --details
```
## Restoring from backup
1. Update your backup storage location to read-only mode (this prevents backup objects from being created or deleted in the backup storage location during the restore process):
```
kubectl patch backupstoragelocation <STORAGE LOCATION NAME> \
    --namespace velero \
    --type merge \
    --patch '{"spec":{"accessMode":"ReadOnly"}}'
```
* storage location name: default (unless configured otherwise)
2. Restore 
```
velero restore create <restore-name> --from-backup <backup-name> 
```
3. When ready, revert your backup storage location to read-write mode:
```
kubectl patch backupstoragelocation <STORAGE LOCATION NAME> \
   --namespace velero \
   --type merge \
   --patch '{"spec":{"accessMode":"ReadWrite"}}'
```
## Creating scheduled backups
 Example: To create a backup every 6 hours with 24 hour retention period. 
* To creates a backup object with the name ``<schedule-name>-<TIMESTAMP>``.
```
velero schedule create <schedule-name> --schedule "0 */6 * * *" --include-resources=pvc,pv --selector <app-label> --ttl 24h
```
* To restore the latest successful backup triggered by the provided schedule.
```
velero restore create <restore-name> --from-schedule <schedule-name>
```
## Note
1. The following labels should be used to backup the resource volumes:
    Redis: app.kubernetes.io/name=redis-cluster
    RabbitMQ: app=rabbitmq
    PostgreSQL: app.kubernetes.io/name=postgresql-ha
    ImmuDB: app.kubernetes.io/name=immudb
2. Upgrading of velero and velero-aws-plugin: 
   velero : velero 1.6 to 1.9 - https://velero.io/docs/v1.9/upgrade-to-1.9/#instructions
   velero-aws-plugin: from v1.2.0 to v1.5.0 ``velero plugin remove velero/velero-plugin-for-aws:v1.2.0 && velero plugin add velero/velero-plugin-for-aws:v1.5.0``


## Migrate persistent volumes across aws availability zone

Creating volumes from a snapshot across availability zones isn't natively supported by velero as of v1.10.1.
As a work-around (suggestions taken from [velero issue](https://github.com/vmware-tanzu/velero/issues/1624#issuecomment-541476780)), the following [script](./velero-change-aws-az.sh) can be used to manually change the snapshot and persistent volume manifests to create the volume in correct availability zone.

- Requires aws cli to be installed and configured with s3 access

Run the script:
```sh
./velero-change-aws-az.sh <bucket-name> <velero-backup-name> <old-az> <new-az>
```

Verify the change:
```sh
velero describe backup <velero-backup-name> --details
```
It should reflect the new availability zone. Proceed with restoring the backup as usual.
