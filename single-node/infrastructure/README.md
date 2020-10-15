# Provisioning Docker Swarm 
## Pre-Requisites
1) Provisioning of VMs

2) Preparation of inventory.yml file using template shown at the end.

3) Firewall rules to setup docker swarm 
- Ssh port 22 needs to open in all VMs.
- Every physical node needs to expose the following ports for Docker swarm:
  - TCP port 2377 for cluster management communications
  - TCP and UDP port 7946 for communication among nodes
  - UDP port 4789 for overlay network traffic

## Install

```yml
# installation of docker and updation of docker daemon.json  in ubuntu hosts as root user 
ansible-playbook -v  provision-docker.yml -i inventory.yml 

# create a docker swarm from one of the manager-nodes
ansible -v <manager-node> -i inventory.yml -m shell -a "sudo docker swarm init --advertise-addr=<private-address>"

# join manager-nodes to swarm
ansible -v manager-nodes  -i inventory.yml -m shell -a "sudo docker swarm join --token <manager-token> <advertise-addr>"

#join worker-nodes to swarm
ansible -v worker-nodes  -i inventory.yml -m shell -a "sudo docker swarm join --token <worker-token> <advertise-addr>"

#create attachable docker overlay-network named "overlay-net" from one of the manager nodes
ansible -v <manager-node>  -i inventory.yml -m shell -a "sudo docker network create --subnet=<subnet> -d overlay --attachable overlay-net"

```

## Template Inventory
```yml
all:
 hosts:
  node1:
    ansible_host: 
  node2:
    ansible_host:
  .... 
 vars: 
   ansible_python_interpreter: /usr/bin/python3
   ansible_user: username			 #  username with which one has ssh access to machines

 children:
   manager-nodes:				 # nodes that needs to be manager
     hosts:
       node1:
       ...
   worker-nodes:				 # nodes that needs to be a worker
     hosts:
       node2:
       ...
   cluster:					 # all docker swarm nodes
     hosts:
       node1:
       node2:
       ...
```
