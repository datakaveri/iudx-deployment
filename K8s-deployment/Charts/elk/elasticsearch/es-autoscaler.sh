#!/bin/sh

Encoded_PASS=$(printf %s "$ES_PASSWORD"|jq -sRr @uri)
es_nodes=$(curl --silent -XGET http://$ES_USERNAME:$Encoded_PASS@elasticsearch:9200/_nodes | jq ._nodes.total | sed -r 's/\s+//g')
es_shards=$(curl --silent -XGET http://$ES_USERNAME:$Encoded_PASS@elasticsearch:9200/_cat/health | awk '{print $7}'| sed -r 's/\s+//g')
jvm_maxheap_per_node=$(curl --silent -XGET http://$ES_USERNAME:$Encoded_PASS@elasticsearch:9200/_cat/nodes?h=heap.max | awk 'NR==1')
all_disk_usage=$(curl --silent -XGET http://$ES_USERNAME:$Encoded_PASS@elasticsearch:9200/_cat/nodes?h=disk.used_percent)

heap_size=$(echo "$jvm_maxheap_per_node"| awk '{print substr($0,1,length($0)-2)}')
heap_unit=$(echo "$jvm_maxheap_per_node" | awk '{print substr($0,length($0)-1,2)}')

if [ "$heap_unit" = "mb" ]
then
    jvm_maxheap_per_node=$(echo "scale=2; $heap_size / 1024" | bc)
else 
    jvm_maxheap_per_node=$(echo "$heap_size")
fi

totalJvmHeap=$(echo "$es_nodes * $jvm_maxheap_per_node" | bc)
shardsPerGbJvmHeap=$(echo "scale=2; $es_shards / $totalJvmHeap"| bc)
maxShardsPerNode=$(echo "18 * $jvm_maxheap_per_node" | bc)
totalDataNodesRequired=$(echo "scale=0; $es_shards/$maxShardsPerNode +1" | bc) 

echo "Data Nodes =" $es_nodes
echo "Shards =" $es_shards
echo "Jvm max heap per node =" $jvm_maxheap_per_node"gb"
# echo "Max shards per node =" $maxShardsPerNode
echo "Total Jvm Heap =" $totalJvmHeap"gb"
echo "Shards per Gb of JVM =" $shardsPerGbJvmHeap
echo "Data nodes required =" $totalDataNodesRequired

if [ $totalDataNodesRequired -gt $es_nodes ]
then
    echo "Scale up es-data-node by  $(($totalDataNodesRequired - $es_nodes))"
    # total data nodes required - 3 master nodes to get total data-only nodes required and set scale
    helm repo add bitnami https://raw.githubusercontent.com/bitnami/charts/archive-full-index/bitnami && helm upgrade --reuse-values --set data.replicaCount=$(($totalDataNodesRequired - 3)) --version 19.2.4 elasticsearch bitnami/elasticsearch -n elastic
    exit 0
else
    echo "No need to scale up"
fi

totalUsage=0

for usage in $all_disk_usage
do 
    usageFloor=$(echo "${usage%.*}")
    usageCeiling=$(echo "scale=0; $usageFloor + 1" |bc)

    totalUsage=$(($totalUsage + $usageCeiling))

done

# echo $totalUsage
totalDiskUsage=$(echo "scale=0; $totalUsage / $es_nodes +1" | bc)

echo "Total Disk Usage =  " $totalDiskUsage"%"

if [ $totalDiskUsage -gt 80 ]
then
    echo "Total disk usage exceeded lower watermark of 80%"
    echo "scaling up replicas"
    # total esNodes-2 to get dataNodes+1
    helm repo add bitnami https://raw.githubusercontent.com/bitnami/charts/archive-full-index/bitnami && helm upgrade --reuse-values --set data.replicas=$(($es_nodes - 2)) --version 19.2.4 elasticsearch bitnami/elasticsearch -n elastic
    exit 0
else
    echo "Total disk usage is below lower watermark ; No need to scale"
fi

