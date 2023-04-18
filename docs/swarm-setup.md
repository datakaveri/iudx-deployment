# Swarm and overlay-net creation

## Pre-Requisites
0) One or more nodes needed to create docker swarm cluster
1) Firewall rules to setup in docker swarm nodes 
    - Outbound traffic to download packages etc.
    - Every physical node needs to expose the following ports for Docker swarm:
        - TCP port 2377 for cluster management communications
        - TCP and UDP port 7946 for communication among nodes
        - UDP port 4789 for overlay network traffic

## Install 
1. At the designated manager node, execute following command
    ```sh
    docker swarm init --advertise-addr <ip_of_this_node> 
    ```
   Preferably use private ip of the node i.e. create docker swarm on top of private network.

2. Get manager tokens and worker node tokens from this manager node:
    ```sh
    # Manager Token
    docker swarm join-token -q manager

    # Worker Token
    docker swarm join-token -q worker
    ```
3. Add worker and manager nodes using token got above
    ```sh
    # Joining the manager nodes, execute at nodes which need to be joined as manager
    docker swarm join --token <manager_token>  <ip_of_first_swarm_manager_node>:2377

    # Joining the worker nodes, execute at nodes which need to be joined as worker nodes
    docker swarm join --token <worker_token>  <ip_of_first_swarm_manager_node>:2377
    ```
4. Create overlay network using the following command on any manager nodes:
    ```sh
    docker network create --driver overlay  --attachable --subnet=<CIDR format subnet, default:-10.0.1.0/24> overlay-net
    ```
   The "overlay-net" subnet CIDR must be different from underlaying private network subnet address range. 
   
## Note
1. If swarm cluster is created on single node/local machine, then step 2 and 3 not needed.
2. Make sure the subnet option (--subnet=10.0.1.0/24) does not conflict with cluster nodes
   subnet networks.
