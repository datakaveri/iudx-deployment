## Description
[**Velero**](https://velero.io/docs/v1.6/) is the tool being used for backing up and restoring the Kubernetes cluster resources. It is being used to backup persistent volumes and persistent volume claims for the following deployments:

- Redis-cluster
- PostgreSQL
- ImmuDB
- RabbitMQ
### Deployment Architecture
Velero consists of:
- A server that runs on your kubernetes cluster.
- A command-line client that runs locally on the bootstrap machine (Rancher server node).
#### Cloud and OSS components
- volume snapshots stored in Azure Blob storage.

## Deployment
### Pre-requisites

- Access to a Kubernetes cluster, v1.12 or later, with DNS and container networking enabled.
- kubectl installed locally.

### Deploy
If you do not have the `az` Azure CLI 2.0 installed locally, follow the [instruction](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) to set it up.
Run:

```bash
az login
```
#### Setup Azure storage account and blob container

Velero requires a storage account and blob container in which to store backups. The storage account needs to be created with a globally unique id since this is used for dns.

Create Azure storage account and blob container, replacing placeholders appropriately:

```bash
AZURE_BACKUP_RESOURCE_GROUP=<YOUR_RESOURCE_GROUP>
AZURE_STORAGE_ACCOUNT_ID=<UNIQUE_NAME> 
//AZURE_STORAGE_ACCOUNT_ID="velero$(uuidgen | cut -d '-' -f5 | tr '[A-Z]' '[a-z]')" for Unique Id

az storage account create \
    --name $AZURE_STORAGE_ACCOUNT_ID \
    --resource-group $AZURE_BACKUP_RESOURCE_GROUP \
    --sku Standard_GRS \
    --encryption-services blob \
    --https-only true \
    --kind BlobStorage \
    --access-tier Hot
```
Create the blob container named velero. Feel free to use a different name, preferably unique to a single Kubernetes cluster.

```bash
BLOB_CONTAINER=<YOUR_CONTAINER_NAME>
az storage container create -n $BLOB_CONTAINER --public-access off --account-name $AZURE_STORAGE_ACCOUNT_ID
```



#### Set permissions for Velero
Set the name of the Resource Group that contains your Kubernetes cluster's virtual machines/disks.

```bash
    AZURE_RESOURCE_GROUP=<NAME_OF_RESOURCE_GROUP>
 ```
Obtain your Azure Account Subscription ID:
   ```
   AZURE_SUBSCRIPTION_ID=`az account list --query '[?isDefault].id' -o tsv`
   ```
##### Set permissions using service principal
There are several ways Velero can authenticate to Azure, here for our deployment gonna use a Velero-specific service principal.
If you don't plan to take Azure disk snapshots, any method is valid.

##### Specify Role
_**Note**: This is only required for (1) by using a Velero-specific service principal and  (2) by using ADD Pod Identity._ 

1. Obtain your Azure Account Subscription ID:
   ```
   AZURE_SUBSCRIPTION_ID=`az account list --query '[?isDefault].id' -o tsv`
   ```
2. Specify the role
Use the following commands to create a custom role which has the minimum required permissions:
   ```
   AZURE_ROLE=Velero
   az role definition create --role-definition '{
      "Name": "Velero",
      "Description": "Velero related permissions to perform backups, restores and deletions",
      "Actions": [
          "Microsoft.Compute/disks/read",
          "Microsoft.Compute/disks/write",
          "Microsoft.Compute/disks/endGetAccess/action",
          "Microsoft.Compute/disks/beginGetAccess/action",
          "Microsoft.Compute/snapshots/read",
          "Microsoft.Compute/snapshots/write",
          "Microsoft.Compute/snapshots/delete",
          "Microsoft.Storage/storageAccounts/listkeys/action",
          "Microsoft.Storage/storageAccounts/regeneratekey/action"
      ],
      "AssignableScopes": ["/subscriptions/'$AZURE_SUBSCRIPTION_ID'"]
      }'
   ```
   _(Optional) If you are using a different Subscription for backups and cluster resources, make sure to specify both subscriptions
   inside `AssignableScopes`._

##### Option 1: Create service principal
1. Obtain your Azure Account Tenant ID:

    ```bash
    AZURE_TENANT_ID=`az account list --query '[?isDefault].tenantId' -o tsv`
    ```

2. Create a service principal.

    If you'll be using Velero to backup multiple clusters with multiple blob containers, it may be desirable to create a unique username per cluster rather than the default `velero`.


    Create service principal and let the CLI generate a password for you. Make sure to capture the password.


    _(Optional) If you are using a different Subscription for backups and cluster resources, make sure to specify both subscriptions
    in the `az` command using `--scopes`._

    ```bash
    AZURE_CLIENT_SECRET=`az ad sp create-for-rbac --name "velero" --role $AZURE_ROLE --query 'password' -o tsv --scopes  /subscriptions/$AZURE_SUBSCRIPTION_ID[ /subscriptions/$AZURE_BACKUP_SUBSCRIPTION_ID]`
    ```

    NOTE: Ensure that value for `--name` does not conflict with other service principals/app registrations.
    
    After creating the service principal, obtain the client id.

    ```bash
    AZURE_CLIENT_ID=`az ad sp list --display-name "velero" --query '[0].appId' -o tsv`
    ```
3. Now you need to create a file that contains all the relevant environment variables. The command looks like the following:

    ```bash
    cat << EOF  > ./credentials-velero
    AZURE_SUBSCRIPTION_ID=${AZURE_SUBSCRIPTION_ID}
    AZURE_TENANT_ID=${AZURE_TENANT_ID}
    AZURE_CLIENT_ID=${AZURE_CLIENT_ID}
    AZURE_CLIENT_SECRET=${AZURE_CLIENT_SECRET}
    AZURE_RESOURCE_GROUP=${AZURE_RESOURCE_GROUP}
    AZURE_CLOUD_NAME=AzurePublicCloud
    EOF
    ```

    > available `AZURE_CLOUD_NAME` values: `AzurePublicCloud`, `AzureUSGovernmentCloud`, `AzureChinaCloud`, `AzureGermanCloud`
    
    
#### Install and start Velero

Install [Velero](https://github.com/vmware-tanzu/velero/releases), including all prerequisites, into the cluster and start the deployment. This will create a namespace called `velero`, and place a deployment named `velero` in it.

**If using service principal**:


```bash
velero install \
    --provider azure \
    --plugins velero/velero-plugin-for-microsoft-azure:v1.4.0 \
    --bucket $BLOB_CONTAINER \
    --secret-file ./credentials-velero \
    --backup-location-config resourceGroup=$AZURE_BACKUP_RESOURCE_GROUP,storageAccount=$AZURE_STORAGE_ACCOUNT_ID[,subscriptionId=$AZURE_BACKUP_SUBSCRIPTION_ID] \
    --snapshot-location-config apiTimeout=<YOUR_TIMEOUT>[,resourceGroup=$AZURE_BACKUP_RESOURCE_GROUP,subscriptionId=$AZURE_BACKUP_SUBSCRIPTION_ID]
```
#### Backup and Restore using Velero
**Backing up**

```bash
velero backup create <backup-name> --include-resources=pvc,pv --selector <resource-label>
```

All backups created can be listed using:

```bash
velero backup get
```

To see more details about the backups:

```bash 
velero backup describe <backup-name> --details
```

**Restoring from backup**

Update your backup storage location to read-only mode (this prevents backup objects from being created or deleted in the backup storage location during the restore process):

    kubectl patch backupstoragelocation <STORAGE LOCATION NAME> \
        --namespace velero \
        --type merge \
        --patch '{"spec":{"accessMode":"ReadOnly"}}'
*storage location name: default (unless configured otherwise)
```bash
velero restore create <restore-name> --from-backup <backup-name>
```
The backed up resources will be restored in the kubernetes cluster under their respective namespaces.
Refer [this](https://velero.io/docs/v1.6/restore-reference/) for advanced options.

When ready, revert your backup storage location to read-write mode:

    kubectl patch backupstoragelocation <STORAGE LOCATION NAME> \
       --namespace velero \
       --type merge \
       --patch '{"spec":{"accessMode":"ReadWrite"}}'

**Creating scheduled backups**

Example: To create a backup every 6 hours with 24 hour retention period-

```bash
velero schedule create <schedule-name> --schedule "0 */6 * * *" --include-resources=pvc,pv --selector <app-label> --ttl 24h    
```
This creates a backup object with the name \<schedule-name\>-\<TIMESTAMP\>

```
velero restore create <restore-name> --from-schedule <schedule-name>
```
This restores the latest successful backup triggered by the provided schedule.


The following labels should be used to backup the resource volumes-

- Redis: `app.kubernetes.io/name=redis-cluster`
- RabbitMQ: `app=rabbitmq`
- PostgreSQL: `app.kubernetes.io/name=postgresql-ha`
- ImmuDB: `app.kubernetes.io/name=immudb`

