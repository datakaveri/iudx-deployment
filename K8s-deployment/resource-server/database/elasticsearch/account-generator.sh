#!/bin/sh

apk add --no-cache curl

elastic_username='elastic'
elastic_password=$(cat /usr/share/secrets/elasticsearch-su-password)

change_password(){
    curl -X POST "$ELASTICSEARCH_HOST/_security/user/$1/_password?pretty" \
        -u $elastic_username:$elastic_password \
        -H 'Content-Type: application/json' \
        --data "{\"password\":\"$2\"}"
}

create_user(){
    curl -X POST "$ELASTICSEARCH_HOST/_security/user/$1" \
        -u $elastic_username:$elastic_password \
        -H 'Content-Type: application/json' \
        --data "{\"password\":\"$2\", \"roles\":$3}"
}

remove_user(){
    curl -X DELETE "$ELASTICSEARCH_HOST/_security/user/$1" \
        -u $elastic_username:$elastic_password
}

create_simple_role(){
    curl -X PUT "$ELASTICSEARCH_HOST/_security/role/$1" \
        -u $elastic_username:$elastic_password \
        -H 'Content-Type: application/json' \
        --data "{\"cluster\":[\"monitor\"],\"indices\":[{\"names\":[\"*\"],\"privileges\":$2}]}"
}


echo 'Waiting for elasticsearch cluster to become ready (request params: "wait_for_status=green&timeout=1s" )'
while [[ "$(curl -s -o /dev/null/ -w '%{http_code}' -u $elastic_username:$elastic_password "$ELASTICSEARCH_HOST/_cluster/health?wait_for_status=green&timeout=1s")" != "200" ]]; do
    sleep 10
done
                

echo 'Updating system-user passwords'

change_password \
    kibana_system \
    $(cat /usr/share/secrets/kibana-system-password)

change_password \
    logstash_system \
    $(cat /usr/share/secrets/logstash-system-password)


create_simple_role "logstash-role" "[\"create\"]"
create_simple_role "rs-role" "[\"read\"]"
create_simple_role "cat-role" "[\"create\",\"read\",\"delete\"]"

create_user \
    $(cat /usr/share/secrets/kibana-admin-username) \
    $(cat /usr/share/secrets/kibana-admin-password) \
    "[\"kibana_admin\",\"superuser\"]"

create_user \
    logstash-internal \
    $(cat /usr/share/secrets/logstash-internal-password) \
    "[\"logstash-role\"]"

create_user \
    rs-user \
    $(cat /usr/share/secrets/elasticsearch-rs-password) \
    "[\"rs-role\"]"

create_user \
    cat-user \
    $(cat /usr/share/secrets/elasticsearch-cat-password) \
    "[\"cat-role\"]"
