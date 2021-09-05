#!/bin/bash

all_cpu_usage=$(curl -fs --data-urlencode 'query=sum(rate(container_cpu_usage_seconds_total{image!="",namespace="redis",pod=~"redis-redis-cluster-[0-9]+"}[5m])) by (pod) * 1000' http://$prometheus_url/api/v1/query | jq -r '.data.result[] | [.metric.pod, .value[1]] | join ("=")')

current_num_nodes=$(redis-cli --cluster call redis-redis-cluster-0.redis-redis-cluster-headless:6379 CLUSTER INFO -a $REDIS_PASSWORD | grep 'cluster_known_nodes' | awk -F: 'NR==1 {print $2}' | tr -d $'\r')
echo "Current number of cluster nodes = $current_num_nodes"
cpu_threshold=$(echo "scale=2;$autoscale_threshold * $redis_resource_limit / 100"| bc)
echo "Auto-scale threshold = $cpu_threshold millicores"
for x in $all_cpu_usage
do
    pod_name=$(echo $x | awk -F= '{print $1}')
    usage=$(echo $x | awk -F= '{print $2}')
    usageCeiling=$(echo "${usage%.*} + 1" | bc)
    if [ $usageCeiling -gt ${cpu_threshold%.*} ]
    then
        echo "Scale out triggered for pod: $pod_name"
	    echo "CPU usage: $usageCeiling"
        output=$(redis-cli --cluster check $pod_name.redis-redis-cluster-headless:6379 -a $REDIS_PASSWORD | awk '{print NR,$0}' | grep "$pod_name" | awk 'END{print}')
        node_type=$(echo $output | awk '{print $2}' | tr -d :)
        if [[ "$node_type" == "S" ]]
        then
            echo "Node type = Slave"
            new_num_nodes=$(echo "1 + $current_num_nodes" | bc)
            echo "Number of cluster nodes after scaling = $new_num_nodes"
            line_num=$(echo $output | awk '{print $1}')
            master_id_line=$(expr $line_num + 2)
            master_id=$(redis-cli --cluster check $pod_name.redis-redis-cluster-headless:6379 -a $REDIS_PASSWORD |awk 'NR=='$master_id_line' {print $2}')
            echo "Master id to replicate: $master_id"
            helm repo add bitnami https://charts.bitnami.com/bitnami
            helm upgrade --timeout 600s --reuse-values redis --set "password=$REDIS_PASSWORD,cluster.update.addNodes=true,cluster.update.currentNumberOfNodes=$current_num_nodes,cluster.nodes=$new_num_nodes,updateJob.nodeType=slave,updateJob.masterID=$master_id" bitnami/redis-cluster -n redis
            exit 0
        elif [[ "$node_type" == "M" ]]
        then
            echo "Node type = Master"
            new_num_nodes=$(echo "2 + $current_num_nodes" | bc)
            echo "Number of cluster nodes after scaling = $new_num_nodes"
            helm repo add bitnami https://charts.bitnami.com/bitnami
            helm upgrade  --version 6.3.3 --timeout 600s --reuse-values redis --set "password=$REDIS_PASSWORD,cluster.update.addNodes=true,cluster.update.currentNumberOfNodes=$current_num_nodes,cluster.nodes=$new_num_nodes,updateJob.nodeType=master" bitnami/redis-cluster -n redis
            sleep 5m
            redis-cli --cluster rebalance redis-redis-cluster:6379 --cluster-use-empty-masters -a $REDIS_PASSWORD
            exit 0
        fi
    else
        echo "CPU usage of pod $pod_name : $usageCeiling millicores | Scale out not triggered."
        echo "----------------"
    fi
done
