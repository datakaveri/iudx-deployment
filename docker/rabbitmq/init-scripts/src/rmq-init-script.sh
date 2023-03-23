#!/bin/bash

init_config=`cat /usr/share/app/init-config.json`

# update admin user details
users=`echo "$init_config"| jq  -r .users`
admin_username=`echo $users | jq -r .[0].username`
admin_password=`cat $(echo $users | jq -r .[0].password_file)`
until [ "$(curl -s -X GET -u "$admin_username":"$admin_password" http://$RMQ_HOST/api/aliveness-test/%2F | jq -r .status | grep 'ok')" ];
do
    echo --- waiting for rabbitmq to start ---
    sleep 10
done
# require RMQ_HOST env variable with value being internal service address + port to rmq host
# create vhosts
vhosts=`echo "$init_config"| jq  -r .vhosts[].vhost_name`
sleep 5
for i in $vhosts; do
    curl  -s -u "$admin_username":"$admin_password" -X PUT "http://$RMQ_HOST/api/vhosts/$i"
    echo "vhost $i created"
done

# create exchanges
exchanges=`echo "$init_config"| jq  -r .exchanges`
exchanges_len=`echo $exchanges| jq length`
echo "$exchanges_len"
for ((i=0; i<$exchanges_len; i++)) ; do
    vhost=`echo $exchanges | jq -r .[$i].exchange_vhost`
    exchange_name=`echo $exchanges | jq -r .[$i].exchange_name`
    exchange_type=`echo $exchanges | jq -r .[$i].exchange_type`
    curl  -s -u "$admin_username":"$admin_password" -X PUT "http://$RMQ_HOST/api/exchanges/$vhost/$exchange_name" -d "{\"type\":\"$exchange_type\",\"auto_delete\":false,\"durable\":true,\"internal\":false,\"arguments\":{}}"
    echo "exchange $exchange_name created"
done

# create queues
queues=`echo "$init_config"| jq  -r .queues`
queues_len=`echo $queues| jq length`
for ((i=0; i < $queues_len; i++)); do
    vhost=`echo $queues | jq -r .[$i].queue_vhost`
    queue_name=`echo $queues | jq -r .[$i].queue_name`
    queue_binding_exchange=`echo $queues | jq -r .[$i].queue_binding_exchange`
    queue_binding_key=`echo $queues | jq -r .[$i].queue_binding_key`
    curl  -s -u "$admin_username":"$admin_password" -X PUT "http://$RMQ_HOST/api/queues/$vhost/$queue_name" -d "{\"auto_delete\":false,\"durable\":true,\"arguments\":{}}"
    echo "queue $queue_name created"
    # create exchange-queue bindings if present
    if [[ -n  $queue_binding_exchange ]]; then
        curl  -s -u "$admin_username":"$admin_password" -X POST "http://$RMQ_HOST/api/bindings/$vhost/e/$queue_binding_exchange/q/$queue_name" -d "{\"routing_key\":\"$queue_binding_key\"}"
        echo "exchange-queue binding $queue_binding_exchange $queue_name created with binding key $queue_binding_key"
    fi
done

# create users , set permissions
users_len=`echo $users | jq length`
for ((i=0; i < $users_len; i++)); do 
    username=`echo $users | jq -r .[$i].username`
    password=`cat $(echo $users | jq -r .[$i].password_file)`
    permissions=`echo $users | jq -r .[$i].permissions`
    tag=`echo $users| jq -r .[$i].role`
    if [[ $tag == "adminstrator" ]]; then
        echo "Adminsrator user already created"
    else
        curl  -s -u "$admin_username":"$admin_password" -X PUT "http://$RMQ_HOST/api/users/$username" -d "{\"password\":\"$password\",\"tags\":\"$tag\"}"
        echo "user $username created"
        # set permissions
        permissions_len=`echo $permissions | jq length`
        for ((j=0;j<$permissions_len;j++)) ; do
            vhost=`echo $permissions | jq -r .[$j].vhost`
            permission=`echo $permissions | jq -r .[$j].permission`
            curl  -s -u "$admin_username":"$admin_password" -X PUT "http://$RMQ_HOST/api/permissions/$vhost/$username" -d "$permission"
        done
        echo "user $username with permissions $permissions created"
    fi
done

# create policies
    policies=`echo "$init_config"| jq  -r .policies`
policies_len=`echo $policies| jq length`
for ((i=0; i < $policies_len; i++)); do
    vhost=`echo $policies | jq -r .[$i].policy_vhost`
    policy_name=`echo $policies | jq -r .[$i].policy_name`
    policy_pattern=`echo $policies | jq -r .[$i].policy_pattern`
    policy_definition=`echo $policies | jq -r .[$i].policy_definition`
    policy_apply=`echo $policies | jq -r .[$i].policy_apply`
    policy_priority=`echo $policies | jq -r .[$i].policy_priority`

    curl -s -u "$admin_username":"$admin_password" -X PUT "http://$RMQ_HOST/api/policies/$vhost/$policy_name" -d "{\"pattern\":\"$policy_pattern\", \"definition\": $policy_definition , \"priority\": $policy_priority, \"apply-to\": \"$policy_apply\"}"
    echo "policy $policy_name created"
done
