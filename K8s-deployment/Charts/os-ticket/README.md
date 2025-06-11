# Installation
This installs osTicket helpdesk system with MySQL database and persistent storage for uploads and configuration.

## Docker image
Custom docker image `ghcr.io/datakaveri/os-ticket:1.0.2` is used for the deployment.

## Create Secrets
1. Generate required secrets using the example template:
```bash
# Copy the example secrets file
cp example-osticket-secrets.yaml osticket-secrets.yaml

# Edit the secrets file with appropriate values
# Required secrets:
# - MYSQL_ROOT_PASSWORD
# - MYSQL_PASSWORD
```

## Create ConfigMap
1. Generate required config using the example template:
```bash
# Copy the example configmap file
cp example-osticket-configmap.yaml osticket-configmap.yaml

# Edit the configmap file with appropriate values
# Required configs:
# - MYSQL_HOST
# - MYSQL_USER
# - MYSQL_DATABASE
```

## Configuration Initialization
The deployment includes a config initialization job (`osticket-config-init-job.yaml`) that:
1. Creates the initial `ost-config.php` file from the sample configuration
2. Mounts it to a persistent volume for data persistence
3. Sets appropriate permissions for the config file

This ensures that the osTicket configuration persists across pod restarts and deployments.

## Deploy
```bash
./install.sh
```

The installation script will:
1. Create the `os-ticket` namespace
2. Create the required Kubernetes secrets
3. Create the required configmaps
4. Deploy the osTicket web application
5. Deploy the MySQL database
6. Set up the ingress for external access

## Components
- **Web Deployment**: Serves the osTicket application
- **MySQL StatefulSet**: Handles the database
- **Persistent Volumes**: 
  - `osticket-uploads`: For file uploads
  - `osticket-config`: For configuration persistence
- **Ingress**: Routes external traffic to the application

## Resource Requirements
The deployment uses the following resource specifications:
- Web Pod:
  - CPU: 1000m-1400m
  - Memory: 1.0Gi-1.5Gi
- MySQL Pod:
  - CPU: 1-2
  - Memory: 2Gi-4Gi
- Storage:
  - Uploads: 5Gi
  - Config: 2Gi
  - MySQL Data: 10Gi

## Note
### Upgradation
When upgrading the deployment:
1. Ensure to backup the persistent volumes
2. Update the image version in the deployment
3. Apply the updated manifests
4. The config initialization job will only run if the config file doesn't exist 