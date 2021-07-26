#!/bin/bash

set -e 

create_secret() {

kubectl create secret generic $1  --dry-run=client --from-file=./secrets/$2 -n postgres  -o yaml | kubeseal --cert ../K8s-cluster/sealed-secrets/sealed-secrets-pub.pem  --format yaml > sealed-secrets/$1.yaml
}

merge_secret() {

 kubectl create secret generic $1 --dry-run=client --from-file=./secrets/$2 -n postgres -o yaml | kubeseal --cert  ../K8s-cluster/sealed-secrets/sealed-secrets-pub.pem --format yaml  --merge-into sealed-secrets/$1.yaml

}

echo -n  $(cat /dev/urandom | tr -dc 'a-zA-Z0-9-!@#$%^&*()+{}|:<>?=' | head -c 16) > secrets/postgresql-password
echo -n  $(cat /dev/urandom | tr -dc 'a-zA-Z0-9-!@#$%^&*()+{}|:<>?=' | head -c 16) > secrets/repmgr-password
echo -n  $(cat /dev/urandom | tr -dc 'a-zA-Z0-9-!@#$%^&*()+{}|:<>?=' | head -c 16) > secrets/postgres-auth-password
echo -n  $(cat /dev/urandom | tr -dc 'a-zA-Z0-9-!@#$%^&*()+{}|:<>?=' | head -c 16) > secrets/postgres-rs-password
echo -n  $(cat /dev/urandom | tr -dc 'a-zA-Z0-9-!@#$%^&*()+{}|:<>?=' | head -c 16) > secrets/postgres-keycloak-password

create_secret psql-passwords postgresql-password
merge_secret psql-passwords repmgr-password
merge_secret psql-passwords postgres-rs-password
merge_secret psql-passwords postgres-auth-password
merge_secret psql-passwords postgres-keycloak-password

echo -n "postgres;iudx_rs_user;iudx_auth_user;iudx_keycloak_user" > secrets/usernames
echo -n "$(cat secrets/postgresql-password);$(cat secrets/postgres-rs-password);$(cat secrets/postgres-auth-password);$(cat secrets/postgres-keycloak-password)" > secrets/passwords

create_secret pgpool-auth usernames
merge_secret pgpool-auth passwords

#create_secret backup-credentials postgresql-password
#merge_secret backup-credentials aws-s3-access-id
#merge_secret backup-credentials aws-s3-access-key

cat << EOF > sealed-secrets/backup-s3-cfg.yaml
apiVersion: bitnami.com/v1alpha1
kind: SealedSecret
metadata:
  creationTimestamp: null
  name: backup-s3-cfg
  namespace: postgres
spec:
  encryptedData:
    aws-s3-access-id: "AgA+dujiBo..."
    aws-s3-access-key: "AgCC4/FvhZ..."
  template:
    metadata:
      creationTimestamp: null
      name: backup-s3-cfg
      namespace: postgres
    data:
     s3cfg : |
       [default]
       access_key = {{ index . "aws-s3-access-id" }}
       secret_key = {{ index . "aws-s3-access-key" }}
       bucket_location = ap-south-1
       host_base = s3.ap-south-1.amazonaws.com
       host_bucket = %(bucket)s.s3.ap-south-1.amazonaws.com
       use_https = true
EOF

merge_secret backup-s3-cfg aws-s3-access-id
merge_secret backup-s3-cfg aws-s3-access-key

