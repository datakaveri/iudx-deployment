# Provisioning node-exporter, docker daemon metrics

## Directory Structure
```sh
.
|-- README.md
|-- deploy-node-exporter-docker-metrics.yml
|-- example-inventory.yml
|-- files
|   `-- node-exporter-manager.sh
`-- templates
    |-- docker-targets.j2
    `-- node-exporter-targets.j2
```
## Inventory
Prepare inventory.yml using the example-inventory.yml file.
## Provisioning Node-exporter and docker daemon metrics

```yml

# installs & starts node-exporter. Also updates targets for node-exporter and docker daemon metrics in the prometheus-node.
ansible-playbook -v deploy-node-exporter-docker-metrics.yml -i inventory.yml

# Start node exporter
ansible nodes-with-exporter -i inventory.yml --become -m script -a  "files/node-exporter-manager.sh -a start" 

# Stop node exporter
ansible nodes-with-exporter -i inventory.yml --become -m script -a  "files/node-exporter-manager.sh -a stop"

# Check status
ansible nodes-with-exporter -i inventory.yml --become -m script -a  "files/node-exporter-manager.sh -a status"

# uninstall node-exporter 
ansible  nodes-with-exporter -i inventory.yml --become  -m script -a  "files/node-exporter-manager.sh -a uninstall"

```

