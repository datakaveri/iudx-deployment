#!/bin/sh

apk add --no-cache curl

elastic_username='elastic'
elastic_password=$(cat /run/secrets/elasticsearch-su-password)

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


echo 'Updating system-user passwords'

change_password \
    kibana_system \
    $(cat /run/secrets/kibana-system-password)

change_password \
    logstash_system \
    $(cat /run/secrets/logstash-system-password)


create_simple_role "logstash-role" "[\"create\"]"
create_simple_role "rs-role" "[\"read\"]"
create_simple_role "cat-role" "[\"create\",\"read\",\"delete\"]"
create_simple_role "fs-role" "[\"read\",\"write\"]"
create_user \
    $(cat /run/secrets/kibana-admin-username) \
    $(cat /run/secrets/kibana-admin-password) \
    "[\"kibana_admin\",\"superuser\"]"

create_user \
    logstash-internal \
    $(cat /run/secrets/logstash-internal-password) \
    "[\"logstash-role\"]"

create_user \
    rs-user \
    $(cat /run/secrets/elasticsearch-rs-password) \
    "[\"rs-role\"]"

create_user \
    cat-user \
    $(cat /run/secrets/elasticsearch-cat-password) \
    "[\"cat-role\"]"

create_user \
    fs-user \
   $(cat /run/secrets/elasticsearch-fs-password) \
   "[\"fs-role\"]"
