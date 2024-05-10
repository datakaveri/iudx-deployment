#!/bin/bash

i=0

read -p "you are going to restart all API servers. Continue (yes/no): " option
#reads all namespaces listed in endpoint.json file
cat $1 | jq -r .namespaces[] | while read ns ;
do 
     if [ $option == "yes" ];then
         echo
	 #command to restart all pods in a namespace
         kubectl delete po -n $ns --all 
         if [ $? == 0 ];then
                echo -e "\033[31m pods in $ns namespace are deleted\033[0m"
                echo waiting for pods to restart....
                sleep 60
         fi
         #assigns each endpoint address to endpoint var to check zero or non-zero status 
         endpoint=$(cat $1 | jq -r .endpoints[$i])
         if [ -z $endpoint ];then
                  ((i++))
                  continue
                 
         else
                  status=$(curl -Lso /dev/null -m 30 $endpoint -w '%{http_code}\n')
                  if [ $status == 200 ];then
                    echo -e "\033[32m ------------------------------------------------------\033[0m"
                    echo -e "\033[32m   ✅ $endpoint is reachable  \033[0m" 
                    echo -e "\033[32m ------------------------------------------------------\033[0m"
                    echo 
                    ((i++))
                    rm -rf endpoint.txt
                    continue
                  else 
                    echo -e "\033[31m⚠⚠⚠\033[0m" Please recheck endpoint "\033[31m$endpoint\033[0m" address!
                    echo -e "\033[31m⚠⚠⚠\033[0m"  Terminating script!
                    echo
                    rm -rf endpoint.txt
                    break
                 fi

         fi
     else
        break
     fi
done
