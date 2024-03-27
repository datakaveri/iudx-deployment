#!/bin/bash
kubectl create namespace zookeeper
helm repo update bitnami
helm install -f zookeeper-values.yaml -f resource-values.yaml zookeeper --version 12.4.1  bitnami/zookeeper -n zookeeper
