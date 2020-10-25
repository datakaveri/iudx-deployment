# Provisioning Swarm, node-exporter, docker daemon metrics

## Directory Structure

|-- README.md
|-- deploy-node-exporter-docker-metrics.yml
|-- deploy-swarm.yml
|-- files
|   |-- docker-daemon.json
|   |-- node-exporter-manager.sh
|   `-- packages-docker-install.sh
|-- inventory.yml
|-- leave-swarm.yml
|-- tasks
|   `-- docker-labels-per-node.yml
`-- templates
    |-- docker-targets.j2
    `-- node-exporter-targets.j2

## Pre-Requisites
1) Provisioning of VMs

2) Preparation of inventory.yml file using template shown at the end.

3) Firewall rules to setup docker swarm 
- Ssh port 22 needs to open in all VMs.
- Outbound traffic to download packages etc.
- Every physical node needs to expose the following ports for Docker swarm:
  - TCP port 2377 for cluster management communications
  - TCP and UDP port 7946 for communication among nodes
  - UDP port 4789 for overlay network traffic

## Provisioning Docker Swarm with required node labels

```yml
# install swarm, overlay network, node labels
ansible-playbook -v  deploy-swarm.yml -i inventory.yml 

# remove overlay and swarm
ansible-playbook -v leave-swarm.yml -i inventory.yml
```
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
##  Template Inventory
```yml

all:
  hosts:
    database:
      ansible_host: w.x.y.z                             # ip/domain name  of host
      host_name: database-node                          # specify the hostname to set in the node
      swarm_node_labels:                                # list of docker swarm node labels for placement policy
        - database_node=true

    monitoring: 
      ansible_host: w.x.y.z
      host_name: monitoring-node
      swarm_node_labels: 
        - monitoring_node=true


  vars: 
    ansible_python_interpreter: /usr/bin/python3        
    ansible_user: xyz                                   # user with which ansible must remote login as 
    ansible_host_key_checking: false
    ansible_ssh_private_key_file: /home/xyz/.ssh/iudx   # ssh private key file location
    private_subnet: 10.20.1.\d+\/24                     # specify the private subnet in perl regex. 
                                                        # Eg. 10.20.1.\d+\/24 for 10.20.1.0/24 for subnet

  children: 
    swarm-first-manager-node:                           # swarm init node and the deployment node 
      hosts:
        monitoring:
      vars:
        swarm_overlay_subnet: 10.0.1.0/24               # specify the ovelay subnet, caution not to clash with private subnet
        swarm_overlay_name: overlay-net                 # name of overlay network 
            
    swarm-manager-nodes:                                # all swarm manager nodes
      hosts:
        monitoring:

    swarm-worker-nodes:                                 # all swarm worker nodes
      hosts:
        database:

    swarm-all-nodes:                                    # all swarm nodes
      hosts:
        database:
        monitoring:
      vars:
        docker_metrics_port: 9323

    prometheus-node:                                     # node on which prometheus will be deployed
      hosts:
        monitoring:

    nodes-with-exporter:                                # nodes on which node-exporter to be installed
      hosts:
        monitoring:
        database:
      vars:
        exporter_metrics_port: 9100

```
