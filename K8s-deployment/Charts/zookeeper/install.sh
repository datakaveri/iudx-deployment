#!/bin/bash
helm repo add bitnami https://raw.githubusercontent.com/bitnami/charts/archive-full-index/bitnami && helm repo update
kubectl create namespace zookeeper
helm install -f zookeeper-values.yaml -f resource-values.yaml zookeeper --version 10.1.1  bitnami/zookeeper -n zookeeper
