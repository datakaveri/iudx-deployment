# RabbitMQ cluster in k8s as a StatefulSet

## Create secret files

1. Make a copy of sample secrets directory and add appropriate values to all files.

```console
 cp -r example-secrets/secrets .
```
2. Generate secrets 
```
./create_secrets.sh
```
3. Generate TLS Certficiates (Letsencrypt) and copy certificate files
to secret directory as shown below: 
```
cp /etc/letsencrypt/live/<domain-name>/chain.pem  secrets/pki/ca.crt

cp /etc/letsencrypt/live/<domain-name>/fullchain.pem  secrets/pki/tls.crt

cp /etc/letsencrypt/live/<domain-name>/privkey.pem secrets/pki/tls.key
```
4. If required, edit the config - ``secrets/init-config.json`` to suit the needs 
for users, exchanges, queues, bindings and policies.
5. Secrets directory after generation of secret files
```sh
secrets/
├── credentials
│   ├── admin-password
│   ├── auditing-password
│   ├── cat-password
│   ├── di-password
│   ├── fs-password
│   ├── gis-password
│   ├── lip-password
│   ├── logstash-password
│   ├── profanity-cat-password
│   ├── rabbitmq-erlang-cookie
│   ├── rs-password
│   ├── rs-proxy-adapter-password
│   └── rs-proxy-password
├── init-config.json
└── pki
    ├── ca.crt
    ├── tls.crt
    └── tls.key
```

## Define Appropriate values of resources

Define Appropriate values of resources -
- CPU request and limits
- RAM request and limits

in `resource-values.yaml` as shown in sample resource-values files for [`aws`](./example-aws-resource-values.yaml) and [`azure`](./example-azure-resource-values.yaml)

Define Appropriate values of loadbalancer configuration -
- Loadbalancer annotations
- Loadbalancer IP

in `external-client-service.yaml` as shown in sample service files for [`aws`](./external-client-aws-service.yaml) and [`azure`](./external-client-azure-service.yaml)

## Deploy
## Installing the Chart

To install the `rabbitmq` chart:

```console
./install.sh
```
The command deploys rabbitmq on the Kubernetes cluster in a 3 node configuration. The Parameters section lists the parameters that can be configured during installation.


The script will create :
1. create a namespace `rabbitmq`
2. create required secrets
3. deploy rabbitmq statefulset and services
4. create required users, exchanges, queues,vhosts, binding & policies 
  in rmq by rmq-init-setup
#### Helpers
```sh
# Pod status, IP, node, etc
kubectl -n rabbitmq get pods -o wide

# RabbitMQ pod logs
kubectl logs -n rabbitmq -f POD_NAME
```
## Uninstalling the Chart

To uninstall/delete the `rabbitmq` deployment:

```console
helm uninstall rabbitmq -n rabbitmq
```
The command removes all the Kubernetes components associated with the chart and deletes the release.


To delete rabbitmq 'pvc'
```console
kubectl delete pvc data-rabbitmq-X -n rabbitmq
```
### Recover the cluster from complete shutdown

> IMPORTANT: Some of these procedures can lead to data loss. Always make a backup beforehand.

The RabbitMQ cluster is able to support multiple node failures but, in a situation in which all the nodes are brought down at the same time, the cluster might not be able to self-recover.

This happens if the pod management policy of the statefulset is not `Parallel` and the last pod to be running wasn't the first pod of the statefulset. If that happens, update the pod management policy to recover a healthy state:

```console
$ kubectl delete statefulset STATEFULSET_NAME --cascade=false
$ helm upgrade RELEASE_NAME my-repo/rabbitmq \
    --set podManagementPolicy=Parallel \
    --set replicaCount=NUMBER_OF_REPLICAS \
    --set auth.password=PASSWORD \
    --set auth.erlangCookie=ERLANG_COOKIE
```

For a faster resyncronization of the nodes, you can temporarily disable the readiness probe by setting `readinessProbe.enabled=false`. Bear in mind that the pods will be exposed before they are actually ready to process requests.

If the steps above don't bring the cluster to a healthy state, it could be possible that none of the RabbitMQ nodes think they were the last node to be up during the shutdown. In those cases, you can force the boot of the nodes by specifying the `clustering.forceBoot=true` parameter (which will execute [`rabbitmqctl force_boot`](https://www.rabbitmq.com/rabbitmqctl.8.html#force_boot) in each pod):

```console
$ helm upgrade RELEASE_NAME my-repo/rabbitmq \
    --set podManagementPolicy=Parallel \
    --set clustering.forceBoot=true \
    --set replicaCount=NUMBER_OF_REPLICAS \
    --set auth.password=PASSWORD \
    --set auth.erlangCookie=ERLANG_COOKIE
```

More information: [Clustering Guide: Restarting](https://www.rabbitmq.com/clustering.html#restarting).

### Known issues

- Changing the password through RabbitMQ's UI can make the pod fail due to the default liveness probes. If you do so, remember to make the chart aware of the new password. Updating the default secret with the password you set through RabbitMQ's UI will automatically recreate the pods. If you are using your own secret, you may have to manually recreate the pods.

## Upgrading

It's necessary to set the `auth.password` and `auth.erlangCookie` parameters when upgrading for readiness/liveness probes to work properly. When you install this chart for the first time, some notes will be displayed providing the credentials you must use under the 'Credentials' section. Please note down the password and the cookie, and run the command below to upgrade your chart:

```bash
$ helm upgrade my-release my-repo/rabbitmq --set auth.password=[PASSWORD] --set auth.erlangCookie=[RABBITMQ_ERLANG_COOKIE]
```
## References

- [Bitnami Rabbitmq Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/rabbitmq)
