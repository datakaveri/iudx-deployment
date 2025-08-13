#!/bin/bash

# Create the namespace
kubectl create namespace mon-stack

# Create secrets
kubectl create secret generic grafana-env-secret --from-env-file=secrets/grafana-env-secret -n mon-stack
kubectl create secret generic grafana-credentials --from-file=./secrets/admin-user --from-file=./secrets/admin-password -n mon-stack
kubectl create secret generic blackbox-targets --from-file=./secrets/blackbox-targets.yaml -n mon-stack

# Create the ConfigMap for Grafana dashboards from the dashboards directory
kubectl create configmap grafana-dashboards-backend \
  --from-file=./grafana/dashboards/Backend/ \
  -n mon-stack

kubectl create configmap grafana-dashboards-general \
  --from-file=./grafana/dashboards/General/ \
  -n mon-stack

kubectl create configmap grafana-dashboards-gateway \
  --from-file=./grafana/dashboards/Gateway/ \
  -n mon-stack

kubectl create configmap grafana-dashboards-kubernetes \
  --from-file=./grafana/dashboards/Kubernetes/ \
  -n mon-stack

kubectl create configmap grafana-dashboards-vertx \
  --from-file=./grafana/dashboards/Vertx\ Applications/ \
  -n mon-stack

kubectl label configmap grafana-dashboards-backend \
  grafana_dashboard=true -n mon-stack

kubectl label configmap grafana-dashboards-general \
  grafana_dashboard=true -n mon-stack

kubectl label configmap grafana-dashboards-gateway \
  grafana_dashboard=true -n mon-stack

kubectl label configmap grafana-dashboards-kubernetes \
  grafana_dashboard=true -n mon-stack

kubectl label configmap grafana-dashboards-vertx \
  grafana_dashboard=true -n mon-stack

# Install Prometheus, Loki, Grafana, Promtail, Blackbox with Helm
helm repo update prometheus-community kube-state-metrics grafana

helm install --version=27.8.0 -n mon-stack prometheus -f prometheus/prometheus-values.yaml -f prometheus/resource-values.yaml prometheus-community/prometheus
sleep 20
helm install --version=6.29.0 -n mon-stack -f loki/loki-values.yaml -f loki/resource-values.yaml loki  grafana/loki
sleep 20
helm install --version=8.12.0 -f grafana/grafana-values.yaml -f grafana/resource-values.yaml  grafana -n mon-stack   grafana/grafana
sleep 20
helm install --version=6.16.6 -f promtail/promtail-values.yaml -f promtail/resource-values.yaml -n mon-stack promtail grafana/promtail
sleep 20
helm install --version=9.4.0 -f blackbox/blackbox-values.yaml -f blackbox/resource-values.yaml -n mon-stack blackbox prometheus-community/prometheus-blackbox-exporter
