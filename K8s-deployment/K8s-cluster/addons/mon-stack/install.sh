#!/bin/bash

kubectl create namespace mon-stack
# certificate fro certmanager
# kubectl create secret tls grafana-tls-secret -n mon-stack --key secrets/pki/privkey.pem --cert secrets/pki/fullchain.pem
# Depreacting sealed secrets
# kubectl apply -f sealed-secrets/
kubectl create secret generic grafana-env-secret   --from-env-file=secrets/grafana-env-secret -n mon-stack
kubectl create secret generic grafana-credentials   --from-file=./secrets/admin-user --from-file=./secrets/admin-password -n mon-stack
kubectl create secret generic blackbox-targets  --from-file=./secrets/blackbox-targets.yaml -n mon-stack

helm repo update prometheus-community kube-state-metric grafana

helm install --version=25.8.2 -n mon-stack prometheus -f prometheus/prometheus-values.yaml -f prometheus/prometheus-resources.yaml  prometheus-community/prometheus
sleep 20
helm install --version=2.11.20 -n mon-stack -f loki/loki-values.yaml -f loki/loki-resources.yaml loki  bitnami/grafana-loki
sleep 20
helm install --version=9.6.6 -f grafana/grafana-values.yaml -f grafana/grafana-resources.yaml  grafana -n mon-stack   bitnami/grafana
sleep 20
helm install --version=6.15.5 -f promtail/promtail-values.yaml -f promtail/promtail-resources.yaml -n mon-stack promtail grafana/promtail
sleep 20
helm install --version=8.6.1 -f blackbox/blackbox-values.yaml -f blackbox/blackbox-resources.yaml -n mon-stack blackbox prometheus-community/prometheus-blackbox-exporter
