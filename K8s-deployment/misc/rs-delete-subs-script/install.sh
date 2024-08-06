kubectl create ns delete-script
kubectl create secret generic delete-script-config --from-file=./secrets/script-config.json -n delete-script
kubectl apply -f Deployment.yaml -n delete-script
