
# Single Docker Container Installation
   
1. Define appropriate compose definitions in docker-compose.custom.yaml to override the base compose file(docker-compose.yaml).The definition can depend on where and for what pupose (test, production, machine specs) its deployed. An example is present for reference.
```sh
# Run Rancher server in docker using docker-compose
docker-compose -f docker-compose.yaml -f docker-compose.custom.yaml up -d
```
2. Refer [official docs](https://ranchermanager.docs.rancher.com/pages-for-subheaders/rancher-on-a-single-node-with-docker) to know more.
