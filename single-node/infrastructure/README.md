# Provisioning Swarm, node-exporter, docker daemon metrics

## Directory Structure
```sh
.
|-- README.md
|-- deploy-swarm.yml
|-- files
|   |-- docker-daemon.json
|   `-- packages-docker-install.sh
|-- example-inventory.yml
|-- leave-swarm.yml
`-- tasks
    `-- docker-labels-per-node.yml
```
## Pre-Requisites
1) Provisioning of VMs

2) Preparation of inventory.yml file from example-inventory.yml.

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
ansible-playbook -v  deploy-swarm.yml -i inventory.yml 

# remove overlay and swarm
ansible-playbook -v leave-swarm.yml -i inventory.yml

```

## Description

The playbook deploy-swarm.yml does following things:
* Installation of docker, other packages: vim, dnsutils, net-tools iputils-ping
* Docker swarm creation 
* Overlay-net creation 
* Assign hostnames (for labels in grafana) 
* Assign docker node labels for placement of databroker, database, nginx, mon-stack components appropriately to the desginated nodes.
