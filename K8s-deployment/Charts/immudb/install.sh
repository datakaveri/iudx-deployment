kubectl create namespace immudb
kubectl create secret generic immudb-admin-password --from-file=secrets/immudb-admin-password -n immudb
kubectl create secret generic hook-secret --from-file=secrets/password -n immudb
helm install immudb . -f values.yaml -f resource-values.yaml  -n immudb