# Grafana Installation
## Building Docker image
```sh
docker build -t <repository>/grafana:<tag> . 
```
## Run 
```sh
docker run --net=<network> -p 3000:3000 --user root  --name grafana -v grafana-volume:/var/lib/grafana \
-e GF_SECURITY_ADMIN_USER=admin \
-e GF_SECURITY_ADMIN_PASSWORD=${admin_passwd} \
-e GF_PATHS_CONFIG=/usr/share/grafana-conf/custom.ini \
-e GF_PATHS_DATA=/var/lib/grafana \
-e GF_PATHS_PROVISIONING=/usr/share/grafana-conf/provisioning 
```
## Descriptiong
conf directory consists of two types of configs:
-  custom.ini - custom configuration of Grafana
- provisioning (sub-dir) - consists configuration for dashboard and datasource provisioning in respective sub-directories of provisioning.

The provisioned dashboards are present at conf/dashboards.
### Note
admin_passwd env variable must be set in shell using   ```sh export admin_passwd=...```
else, if not set it will create default user admin and passwd as admin.
