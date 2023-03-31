openssl ecparam -name secp256k1 -genkey -noout -out privateECDSASHA256.pem
openssl ec -in privateECDSASHA256.pem -pubout > pubECDSASHA256.pem
docker build -t ghcr.io/datakaveri/nginx-rtmp:v1 .
docker push ghcr.io/datakaveri/nginx-rtmp:v1
kubectl create ns nginx-rtmp
kubectl create secret generic certificates  --from-file=./privateECDSASHA256.pem  --from-file=./pubECDSASHA256.pem -n nginx-rtmp
kubectl apply -f deployment.yaml -n nginx-rtmp
