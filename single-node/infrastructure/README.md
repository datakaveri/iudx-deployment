# Provisioning docker Swarm 
## Pre-Requisites
1) Provisioning of VMs 

2) Firewall rules to setup docker swarm 
- Ssh port 22 needs to open in all VMs
Every physical node needs to expose the following ports for docker swarm:
- TCP port 2377 for cluster management communications
- TCP and UDP port 7946 for communication among nodes
- UDP port 4789 for overlay network traffic

## Install

```yml
# installation of docker and updation of docker daemon.json  in ubuntu hosts
ansible-playbook -v  provision-docker.yml -i inventory.yml 

# create a docker swarm from one of the manager-nodes
ansible -v <manager-node> -i inventory.yml -m shell -a "docker swarm init --advertise-addr=<private-address>"

# join manager-nodes to swarm
ansible -v manager-nodes  -i inventory.yml -m shell -a "docker swarm join --token <manager-token> <advertise-addr>"

#join worker-nodes to swarm
ansible -v worker-nodes  -i inventory.yml -m shell -a "docker swarm join --token <worker-token> <advertise-addr>"

#create attachable docker overlay-network named "overlay-net" from one of the manager nodes
ansible -v <manager-node>  -i inventory.yml -m shell -a "docker network create --subnet=<subnet> -d overlay --attachable overlay-net"

```

## Template Inventory
```yml
all:
 hosts:
   ... 
 vars: 
   ansible_python_interpreter: /usr/bin/python3
   ansible_user: root

 children:
   manager-nodes:
     hosts:
       ...
   worker-nodes:
     hosts:
       ...
   cluster:
     hosts:
       ...
```
