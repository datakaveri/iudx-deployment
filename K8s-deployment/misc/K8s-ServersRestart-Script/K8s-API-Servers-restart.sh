#!/bin/bash


i=0
#reads all namespaces listed in endpoint.json file

cat $1 | jq -r .namespaces[] | while read ns ;
do 
        kubectl delete po -n $ns --all --dry-run=client
        if [ $? == 0 ];then
                echo -e "\033[31m pods in $ns namespace are deleted\033[0m"
                echo waiting for pods to restart....
                sleep 30
        fi
        if [ $ns == "lip" ] || [ $ns == "auditing" ];then
                sleep 60
                ((i++))
                continue
        else
        #reads all API server endpoints listed in endpoint.json file to check endpoint's health

        cat $1 | jq -r .endpoints[$i] > endpoint.txt
        while read endpoint; 
        do
                status=$(curl -Lso /dev/null -m 30 $endpoint -w '%{http_code}\n')
                if [ $status == 200 ];then
                 echo -e "\033[32m ------------------------------------------------------\033[0m"
                 echo -e "\033[32m   ✅ $endpoint is reachable  \033[0m" 
                 echo -e "\033[32m ------------------------------------------------------\033[0m"
                 echo 
                 ((i++))
		 rm -rf endpoint.txt
                 break
                else 
                 echo -e "\033[31m⚠⚠⚠\033[0m" Please recheck endpoint "\033[32m$endpoint\033[0m" address!
                 echo -e "\033[31m⚠⚠⚠\033[0m"  Terminating script!
                 echo
		 rm -rf endpoint.txt
                 break 2
                fi
        done < endpoint.txt
        fi
done  
