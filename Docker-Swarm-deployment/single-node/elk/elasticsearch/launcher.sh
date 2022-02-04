#!/bin/sh

if [[ $1 == "remove-s3-plugin" ]]; then
    elasticsearch-plugin remove repository-s3 ${@:2}
    exit
fi

if [[ ! -d plugins/repository-s3 ]]; then 
    elasticsearch-plugin install --batch repository-s3
else 
    echo 'skipping installation'
fi

exec /usr/local/bin/docker-entrypoint.sh $@