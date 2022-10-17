#!/bin/bash
set -eu 
docker volume create mon-stack_grafana-volume
docker volume create mon-stack_loki-volume
docker volume create mon-stack_loki-wal-volume
docker volume create mon-stack_prometheus-volume
docker volume create mon-stack_promtail-volume
sleep 10
docker stack deploy -c init-containers.yaml monstack-init
sleep 30
docker stack ps monstack-init
docker stack rm monstack-init
docker stack deploy -c mon-stack.yaml -c mon-stack.resources.yaml mon-stack
