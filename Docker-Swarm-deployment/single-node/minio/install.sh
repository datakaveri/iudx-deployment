#!/bin/bash
set -eu 
docker stack deploy -c minio-stack.yaml -c minio-stack.resources.yaml minio
docker stack deploy -c init-containers.yaml minio-init