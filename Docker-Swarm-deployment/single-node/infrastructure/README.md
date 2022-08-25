# Provisioning Infrastructure

## Directory Structure
```sh
.
|-- README.md
|-- deploy-swarm.yaml
|-- files
|   |-- docker-daemon.json
|   `-- packages-docker-install.sh
|-- example-inventory.yaml
|-- leave-swarm.yaml
`-- tasks
    `-- docker-labels-per-node.yaml
```
## Pre-Requisites
1) Provisioning of VMs

2) Preparation of inventory.yaml file from example-inventory.yaml.

3) Firewall rules to setup docker swarm 
- Ssh port 22 needs to open in all VMs.
- Outbound traffic to download packages etc.
- Every physical node needs to expose the following ports for Docker swarm:
  - TCP port 2377 for cluster management communications
  - TCP and UDP port 7946 for communication among nodes
  - UDP port 4789 for overlay network traffic

## Provisioning Docker Swarm, overlay network with required node labels

```yml

# install swarm, overlay network, node labels
ansible-playbook -v  deploy-swarm.yaml -i inventory.yaml 

# install swarm, overlay, node labels in localhost machine
ansible-playbook -v  deploy-swarm.yaml -i inventory.yaml --ask-become-pass --connection=local


# remove overlay and swarm
ansible-playbook -v leave-swarm.yaml -i inventory.yaml

# remove overlay and swarm in localhost machine
ansible-playbook -v  leave-swarm.yaml -i inventory.yaml --ask-become-pass --connection=local

```

### Description

The playbook deploy-swarm.yaml does following things:
* Installation of docker, other packages: vim, dnsutils, net-tools iputils-ping
* Docker swarm creation 
* Overlay-net creation 
* Assign hostnames (for labels in grafana) 
* Assign docker node labels for placement of databroker, database, nginx, mon-stack components appropriately to the desginated nodes.

## Provisioning Node-exporter and docker daemon metrics

```yml

# installs & starts node-exporter. Also updates targets for node-exporter and docker daemon metrics in the prometheus-node.
ansible-playbook -v deploy-node-exporter-docker-metrics.yaml -i inventory.yaml

# installs & starts node-exporter in localhost machine
ansible-playbook -v deploy-node-exporter-docker-metrics.yaml  -i inventory.yaml --ask-become-pass --connection=local

```
Some miscellaneous commands to manage node exporter

```
# Start node exporter
ansible nodes-with-exporter -i inventory.yaml --become -m script -a  "files/node-exporter-manager.sh -a start" 

# Stop node exporter
ansible nodes-with-exporter -i inventory.yaml --become -m script -a  "files/node-exporter-manager.sh -a stop"

# Check status
ansible nodes-with-exporter -i inventory.yaml --become -m script -a  "files/node-exporter-manager.sh -a status"

# uninstall node-exporter 
ansible  nodes-with-exporter -i inventory.yaml --become  -m script -a  "files/node-exporter-manager.sh -a uninstall"
```
