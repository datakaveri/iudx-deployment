#!/bin/bash

set -e 

create_secret() {

	kubectl create secret generic $1  --dry-run=client --from-file=./secrets/$2 -n redis  -o yaml | kubeseal --cert ../K8s-cluster/sealed-secrets/sealed-secrets-pub.pem  --format yaml > sealed-secrets/$1.yaml
}

merge_secret() {

	 kubectl create secret generic $1 --dry-run=client --from-file=./secrets/$2 -n redis -o yaml | kubeseal --cert  ../K8s-cluster/sealed-secrets/sealed-secrets-pub.pem --format yaml  --merge-into sealed-secrets/$1.yaml

 }

echo -n  $(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 30) > secrets/redis-password

create_secret redis-passwords redis-password
