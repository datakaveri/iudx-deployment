# Introduction
Docker swarm stack for clickhouse deployment

## Clickhouse Installation
## Hardware Requirements

1. **CPU**:
   - ClickHouse is CPU-intensive, and more cores result in better performance.
   - Recommended: **4 to 6 cores** or more per node.
   
2. **Memory (RAM)**:
   - ClickHouse performs best with more memory, especially for large datasets.
   - Minimum: **16 GB** RAM.
   - Recommended: **32 GB** RAM or more, depending on data size and workload.

## Assign node labels
 The clickhouse container is constrained to run on specifc node by adding node labels to only one of the nodes, refer [here](https://docs.docker.com/engine/swarm/services/#placement-constraints) for more info. This ensures the container is placed always to same node on restart and able to mount the same local docker volume.

 On the node 1 add :-
```sh
docker node update --label-add clickhouse-node_1=true <node_name>
```
  On the node 2 add :-
```sh
docker node update --label-add clickhouse-node_2=true <node_name>
```
## Define Appropriate values of resources

Define Appropriate values of resources -
- CPU 
- RAM 
- PID limit 
in `clickhouse-stack.resources.yaml`  for clickhouse as shown in sample resource-values file for [here](clickhouse-stack.resources.yaml)

## Deploy
Deploy clickhouse stack:
```sh
docker stack deploy -c clickhouse-stack.yaml -c clickhouse-stack.resources.yaml clickhouse
```