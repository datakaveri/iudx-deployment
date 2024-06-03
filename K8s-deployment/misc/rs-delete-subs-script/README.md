# Introduction
K8s deployment for rs delete script.

# Image Creation and Script
For Script and Image creation, refer the in Resource Server, [here](https://github.com/datakaveri/iudx-resource-server/tree/master/scripts) 

# Installation of refresh script
## Create secret files
1. Make a copy of sample secrets directory 
```console
 cp -r example-secrets/* .
```
2. Substitute appropriate values whatever required in secret-config files in the place holders “<>”
3. Give the appropriate value of node-selector in [Deployment.yaml](Deployment.yaml)

4. Secrets directory after generation of secret files
```sh
secrets/
└──  script-config.json

```
# Deploy 
## Bring up deployment in kubernetes environment 

```
./install.sh
```
