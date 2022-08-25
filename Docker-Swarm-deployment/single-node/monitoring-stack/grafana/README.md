# Grafana Installation
## Building Docker image
```sh
docker build -t ghcr.io/datakaveri/grafana:8.1.8 --build-arg grafana_version=8.1.8 .
```
## Description
conf directory consists of two types of configs:
-  custom.ini - custom configuration of Grafana
- provisioning (sub-dir) - consists configuration for dashboard and datasource provisioning in respective sub-directories of provisioning.

The provisioned dashboards are present at conf/dashboards.
