#!/bin/bash

if [[ $# -eq 0 || $1 == "--staging" ]];
then
    # Execute cert generation script
    ./generate-certs.sh $@

    # Start nginx service 
    ./docker-entrypoint.sh nginx -g "daemon off;"
else
    exec "$@"
fi