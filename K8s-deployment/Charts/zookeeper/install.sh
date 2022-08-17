#!/bin/bash
helm repo add bitnami https://raw.githubusercontent.com/bitnami/charts/43174e1970616584f893f66c1fbcac00d110c633/bitnami/ && helm repo update
kubectl create namespace zookeeper && helm install -f zookeeper-values-yaml -f resource-values.yaml zookeeper --version 7.4.3  bitnami/zookeeper -n zookeeper
