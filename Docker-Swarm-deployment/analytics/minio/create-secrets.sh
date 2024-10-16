#!/bin/bash
set -e 

mkdir -p secrets/passwords
echo -n $(cat /dev/urandom | tr -dc 'a-zA-Z' | head -c 16) > secrets/passwords/minio-username
echo -n $(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 16) > secrets/passwords/minio-password