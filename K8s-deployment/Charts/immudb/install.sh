kubectl create namespace immudb
kubectl create secret generic immudb-admin-password --from-file=../secrets/immudb/immudb-admin-password -n immudb
kubectl create secret generic hook-secret --from-file=../secrets/immudb/password -n immudb
helm install immudb . -f values.yaml -f resource-values.yaml  -n immudb