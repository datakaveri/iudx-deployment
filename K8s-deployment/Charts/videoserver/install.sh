docker build -t ghcr.io/datakaveri/videoserver:v1 .
docker push ghcr.io/datakaveri/videoserver:v1
kubectl create ns videoserver
kubectl apply -f deployment.yaml -n videoserver
