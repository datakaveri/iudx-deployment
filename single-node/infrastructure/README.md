# Provisioning Docker Swarm 
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

## Docker Swarm with required node labels

```yml
# install swarm, overlay network, node labels
ansible-playbook -v  deploy-swarm.yml -i inventory.yml 

# remove overlay and swarm
ansible-playbook -v leave-swarm.yml -i inventory.yml
```
##  Node-exporter and docker daemon metrics

```yml

# installs and starts node-exporter and  update targets for node-exporter and docker daemon metrics in prometheus-node
ansible-playbook -v deploy-node-exporter-docker-metrics.yml -i inventory.yml

# Start node exporter
ansible nodes-with-exporter -i inventory.yml -m script -a --become "files/node-exporter-manager.sh -a start"

# Stop node exporter
ansible nodes-with-exporter -i inventory.yml -m script -a --become "files/node-exporter-manager.sh -a stop"

# Check status
ansible nodes-with-exporter -i inventory.yml -m script -a --become "files/node-exporter-manager.sh -a status"

# uninstall node-exporter 
ansible  nodes-with-exporter -i inventory.yml -m script -a --become "files/node-exporter-manager.sh -a uninstall"

```
## Template Inventory
```yml
all:
  hosts:
    database:
      ansible_host: w.x.y.z
      host_name: database-node
      swarm_node_labels:
        - database_node=true

    monitoring: 
      ansible_host: w.x.y.z
      host_name: monitoring-node
      swarm_node_labels: 
        - monitoring_node=true


  vars: 
    ansible_python_interpreter: /usr/bin/python3        
    ansible_user:                                       # user with which ansible must login as 
    ansible_host_key_checking: false
    ansible_ssh_private_key_file:                       # ssh private key file location
    private_subnet:                                     # specify the private subnet in regex. 
							# Eg. 10.20.1.\d+\/24 for 10.20.1.0/24 for subnet

  children: 
    swarm-first-manager-node:
      hosts:
        monitoring:
      vars:
        swarm_overlay_subnet: 10.0.1.0/24               # specify the ovelay subnet, caution not to clash with private subnet
        swarm_overlay_name: overlay-net                 # name of overlay network 
            
    swarm-manager-nodes:                                
      hosts:
        monitoring:

    swarm-worker-nodes:
      hosts:
        database:

    swarm-all-nodes:
      hosts:
        database:
        monitoring:
      vars:
        docker_metrics_port: 9323

    prometheus-node:
      hosts:
        monitoring:

    nodes-with-exporter:
      hosts:
        monitoring:
        database:
      vars:
        exporter_metrics_port: 9100

```
