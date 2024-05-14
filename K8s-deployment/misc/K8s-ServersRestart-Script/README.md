
# Script to restart K8s based API Servers.

This script performs operation of restarting all API servers in a sequence enumerated in `config.json` file.

## Usage:
- Run `K8s-API-Servers-restart.sh` using the below command and `config.json` file as an argument
- Customize `config.json` as per the need depending upon which servers are to be restarted


    `./K8s-API-Servers-restart.sh config.json`

**_NOTE:_**
 Make sure the list of endpoints and namespaces in **config.json** file are mapped correctly before running script.
