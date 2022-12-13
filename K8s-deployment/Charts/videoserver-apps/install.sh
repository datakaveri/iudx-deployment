docker build -t ghcr.io/datakaveri/video-server-apps:v1 .
docker push ghcr.io/datakaveri/video-server-apps:v1
kubectl create secret topics --from-file=./topics.json
kubectl apply -f jobs.yaml -n kafka