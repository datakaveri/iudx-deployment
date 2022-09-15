#!/bin/bash
helm repo add bitnami https://charts.bitnami.com/bitnami
kubectl create namespace zookeeper &&  helm install -f zookeeper-values.yaml -f resource-values.yaml zookeeper --version 10.1.1  bitnami/zookeeper -n zookeeper
