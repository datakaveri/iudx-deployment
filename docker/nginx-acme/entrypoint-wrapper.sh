#!/bin/bash

if [ $# -gt 0 ]; 
then
    exec "$@"
else
    # Start acme cron in foreground
    cron -f &

    # Execute cert generation script
    ./generate-certs.sh

    # Start nginx service 
    ./docker-entrypoint.sh &

    # Wait for next process to exit
    wait -n

    # Exit with status of process that exited first
    exit $?
fi