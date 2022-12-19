## Introduction

Helm Chart for IUDX immudb Server Deployment

## Docker image 
``ghcr.io/datakaveri/immudb-config-generator:1.4.0`` custom docker image containing the python script to do initial setup of immudb like create users, tables required for the api-servers. The files are present at ``../../../Docker-Swarm-deployment/single-node/immudb/docker/immudb-config-generator``

## Generating secrets

Make a copy of sample secrets directory:

```console
cp -r example-secrets/secrets .
```
To generate the passwords:

```console
./create-secrets.sh
```
```
# secrets directory after generation of secret files
secrets/
└── passwords/
    ├── admin-password
    ├── auth-password
    ├── cat-password
    └── rs-password
```
Configure the env file .config.env in secret/ appropriately
## Define Appropriate values of resources

Define Appropriate values of resources -
- CPU requests and limits
- RAM requests and limits
- Instance-type for nodeSelector
- StorageClassName
- Size of the persistent volume required

in `resource-values.yaml` as shown in sample resource-values file for [`aws`](./example-aws-resource-values.yaml) and [`azure`](./example-azure-resource-values.yaml)

## Installing the Chart

To install the `immudb`chart:

```console
./install.sh  
```

The command deploys  resource-server on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

Following script will create :
1. create a namespace `immudb`
2. create required secrets
3. deploy immudb verticles 
4. Post-install Hook will configure the immudb
5. Deploy the immudb audit-mode for tampering

## Installing immuclient instance (optional)
- Can be used to connect to immudb to perform manual database operations.

Deploy using the following command:
```sh
kubectl apply -f immuclient.yaml -n immudb
```
To access immuclient pod:
```sh
kubectl exec -it $(kubectl get pods -n immudb | awk '{print $1}' | grep 'immudb-client') /bin/bash -n immudb
```
To login to immuclient shell
```sh
/app/immuclient login immudb --password $immudb_admin_password
/app/immuclient 
```

## Uninstalling the Chart

To uninstall/delete the `immudb` deployment:

```console
helm uninstall immudb -n immudb
```
The command removes all the Kubernetes components associated with the chart and deletes the release.


To delete immudb 'pvc'
```console
kubectl delete pvc data-immudb-0 -n immudb
```


## Parameters

### Global parameters

| Name                      | Description                                     | Value |
| ------------------------- | ----------------------------------------------- | ----- |
| `global.imageRegistry`    | Global Docker image registry                    | `""`  |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]`  |
| `global.storageClass`     | Global StorageClass for Persistent Volume(s)    | `""`  |


### Common parameters

| Name                     | Description                                                                             | Value           |
| ------------------------ | --------------------------------------------------------------------------------------- | --------------- |
| `nameSpace`              | Namespace to deploy the controller                                                      | `immudb`        |
| `kubeVersion`            | Override Kubernetes version                                                             | `""`            |
| `nameOverride`           | String to partially override common.names.fullname                                      | `""`            |
| `fullnameOverride`       | String to fully override common.names.fullname                                          | `""`            |
| `commonLabels`           | Labels to add to all deployed objects                                                   | `{}`            |
| `commonAnnotations`      | Annotations to add to all deployed objects                                              | `{}`            |
| `clusterDomain`          | Kubernetes cluster domain name                                                          | `cluster.local` |
| `extraDeploy`            | Array of extra objects to deploy with the release                                       | `[]`            |
| `diagnosticMode.enabled` | Enable diagnostic mode (all probes will be disabled and the command will be overridden) | `false`         |
| `diagnosticMode.command` | Command to override all containers in the deployment                                    | `["sleep"]`     |
| `diagnosticMode.args`    | Args to override all containers in the deployment                                       | `["infinity"]`  |


### Image Parameters

| Name                        | Description                                | Value          |
| --------------------------- | ------------------------------------------ | -------------- |
| `image.registry`            | image registry                             | `codenotary`   |
| `image.repository`          | image repository                           | `immudb`       |
| `image.tag`                 | image tag (immutable tags are recommended) | `1.4.1`        |
| `image.pullPolicy`          | image pull policy                          | `IfNotPresent` |
| `image.pullSecrets`         | image pull secrets                         | `{}`           |
| `image.debug`               | Enable image debug mode                    | `false`        |
| `containerPorts.http`       | HTTP container port                        | `80`           |
| `containerPorts.hazelcast`  | Hazelcast container port                   | `5701`         |
| `containerPorts.prometheus` | Prometheus container port                  | `9000`         |
| `podAnnotations`            | Annotations for pods                       | `nil`          |


### Immudb Parameters

| Name                                           | Description                                                                                                                                         | Value                                |
| ---------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------ |
| `immudb.replicaCount`                          | Number of immudb replicas to deploy                                                                                                                 | `1`                                  |
| `immudb.livenessProbe.enabled`                 | Enable livenessProbe on immudb containers                                                                                                           | `false`                              |
| `immudb.livenessProbe.initialDelaySeconds`     | Initial delay seconds for livenessProbe                                                                                                             | `60`                                 |
| `immudb.livenessProbe.periodSeconds`           | Period seconds for livenessProbe                                                                                                                    | `10`                                 |
| `immudb.livenessProbe.timeoutSeconds`          | Timeout seconds for livenessProbe                                                                                                                   | `10`                                 |
| `immudb.livenessProbe.failureThreshold`        | Failure threshold for livenessProbe                                                                                                                 | `10`                                 |
| `immudb.livenessProbe.path`                    | Path for httpGet                                                                                                                                    | `/metrics`                           |
| `immudb.readinessProbe.enabled`                | Enable readinessProbe on immudb containers                                                                                                          | `false`                              |
| `immudb.readinessProbe.initialDelaySeconds`    | Initial delay seconds for readinessProbe                                                                                                            | `60`                                 |
| `immudb.readinessProbe.periodSeconds`          | Period seconds for readinessProbe                                                                                                                   | `10`                                 |
| `immudb.readinessProbe.timeoutSeconds`         | Timeout seconds for readinessProbe                                                                                                                  | `10`                                 |
| `immudb.readinessProbe.failureThreshold`       | Failure threshold for readinessProbe                                                                                                                | `10`                                 |
| `immudb.readinessProbe.successThreshold`       | Success threshold for readinessProbe                                                                                                                | `10`                                 |
| `immudb.startupProbe.enabled`                  | Enable startupProbe on immudb containers                                                                                                            | `false`                              |
| `immudb.startupProbe.initialDelaySeconds`      | Initial delay seconds for startupProbe                                                                                                              | `10`                                 |
| `immudb.startupProbe.periodSeconds`            | Period seconds for startupProbe                                                                                                                     | `10`                                 |
| `immudb.startupProbe.timeoutSeconds`           | Timeout seconds for startupProbe                                                                                                                    | `10`                                 |
| `immudb.startupProbe.failureThreshold`         | Failure threshold for startupProbe                                                                                                                  | `10`                                 |
| `immudb.startupProbe.successThreshold`         | Success threshold for startupProbe                                                                                                                  | `10`                                 |
| `immudb.customLivenessProbe`                   | Custom livenessProbe that overrides the default one                                                                                                 | `nil`                                |
| `immudb.customReadinessProbe`                  | Custom readinessProbe that overrides the default one                                                                                                | `nil`                                |
| `immudb.customStartupProbe`                    | Custom startupProbe that overrides the default one                                                                                                  | `{}`                                 |
| `immudb.resources`                             | resource requests and limits                                                                                                                        | `{}`                                 |
| `immudb.podSecurityContext.enabled`            | Enabled immudb pods' Security Context                                                                                                               | `true`                               |
| `immudb.podSecurityContext.fsGroup`            | Set immudb pod's Security Context fsGroup                                                                                                           | `3322`                               |
| `immudb.podSecurityContext.runAsGroup`         | Set immudb pod's Security Context runAsGroup                                                                                                        | `3322`                               |
| `immudb.podSecurityContext.runAsUser`          | Set immudb pod's Security Context runAsUser                                                                                                         | `3322`                               |
| `immudb.containerSecurityContext.enabled`      | Enabled immudb containers' Security Context                                                                                                         | `false`                              |
| `immudb.containerSecurityContext.runAsUser`    | Set immudb containers' Security Context runAsUser                                                                                                   | `1001`                               |
| `immudb.containerSecurityContext.runAsNonRoot` | Set immudb containers' Security Context runAsNonRoot                                                                                                | `true`                               |
| `immudb.existingConfigmap`                     | The name of an existing ConfigMap with your custom configuration for immudb                                                                         | `nil`                                |
| `immudb.command`                               | Override default container command (useful when using custom images)                                                                                | `[]`                                 |
| `immudb.args`                                  | Override default container args (useful when using custom images)                                                                                   | `[]`                                 |
| `immudb.hostAliases`                           | immudb pods host aliases                                                                                                                            | `[]`                                 |
| `immudb.podLabels`                             | Extra labels for immudb pods                                                                                                                        | `{}`                                 |
| `immudb.podAffinityPreset`                     | Pod affinity preset. Ignored if `immudb.affinity` is set. Allowed values: `soft` or `hard`                                                          | `""`                                 |
| `immudb.podAntiAffinityPreset`                 | Pod anti-affinity preset. Ignored if `immudb.affinity` is set. Allowed values: `soft` or `hard`                                                     | `""`                                 |
| `immudb.nodeAffinityPreset.type`               | Node affinity preset type. Ignored if `immudb.affinity` is set. Allowed values: `soft` or `hard`                                                    | `""`                                 |
| `immudb.nodeAffinityPreset.key`                | Node label key to match. Ignored if `immudb.affinity` is set                                                                                        | `""`                                 |
| `immudb.nodeAffinityPreset.values`             | Node label values to match. Ignored if `immudb.affinity` is set                                                                                     | `[]`                                 |
| `immudb.affinity`                              | Affinity for immudb pods assignment                                                                                                                 | `{}`                                 |
| `immudb.nodeSelector`                          | Node labels for immudb pods assignment                                                                                                              | `nil`                                |
| `immudb.tolerations`                           | Tolerations for immudb pods assignment                                                                                                              | `[]`                                 |
| `immudb.updateStrategy.type`                   | immudb statefulset strategy type                                                                                                                    | `RollingUpdate`                      |
| `immudb.priorityClassName`                     | immudb pods' priorityClassName                                                                                                                      | `""`                                 |
| `immudb.schedulerName`                         | Name of the k8s scheduler (other than default) for immudb pods                                                                                      | `""`                                 |
| `immudb.lifecycleHooks`                        | for the immudb container(s) to automate configuration before or after startup                                                                       | `{}`                                 |
| `immudb.extraEnvVars`                          | Array with extra environment variables to add to immudb nodes                                                                                       | `nil`                                |
| `immudb.extraEnvVarsCM`                        | Name of existing ConfigMap containing extra env vars for immudb nodes                                                                               | `""`                                 |
| `immudb.extraEnvVarsSecret`                    | Name of existing Secret containing extra env vars for immudb nodes                                                                                  | `nil`                                |
| `immudb.extraVolumes`                          | Optionally specify extra list of additional volumes for the immudb pod(s)                                                                           | `nil`                                |
| `immudb.extraVolumeMounts`                     | Optionally specify extra list of additional volumeMounts for the immudb container(s)                                                                | `nil`                                |
| `immudb.sidecars`                              | Add additional sidecar containers to the immudb pod(s)                                                                                              | `{}`                                 |
| `immudb.initContainers`                        | Add additional init containers to the immudb pod(s)                                                                                                 | `{}`                                 |
| `immudb.persistence.enabled`                   | Enable persistence using a `PersistentVolumeClaim`                                                                                                  | `true`                               |
| `immudb.persistence.storageClass`              | Persistent Volume Storage Class                                                                                                                     | `ebs-storage-class`                  |
| `immudb.persistence.existingClaim`             | Existing Persistent Volume Claim                                                                                                                    | `""`                                 |
| `immudb.persistence.existingVolume`            | Existing Persistent Volume for use as volume match label selector to the `volumeClaimTemplate`. Ignored when `immudb.persistence.selector` ist set. | `""`                                 |
| `immudb.persistence.selector`                  | Configure custom selector for existing Persistent Volume. Overwrites `immudb.persistence.existingVolume`                                            | `{}`                                 |
| `immudb.persistence.annotations`               | Persistent Volume Claim annotations                                                                                                                 | `{}`                                 |
| `immudb.persistence.accessModes`               | Persistent Volume Access Modes                                                                                                                      | `["ReadWriteOnce"]`                  |
| `immudb.persistence.size`                      | Persistent Volume Size                                                                                                                              | `20Gi`                               |
| `immudb.autoscaling.enabled`                   | Enable Horizontal POD autoscaling for Apache                                                                                                        | `false`                              |
| `immudb.autoscaling.minReplicas`               | Minimum number of Apache replicas                                                                                                                   | `1`                                  |
| `immudb.autoscaling.maxReplicas`               | Maximum number of Apache replicas                                                                                                                   | `5`                                  |
| `immudb.autoscaling.targetCPU`                 | Target CPU utilization percentage                                                                                                                   | `80`                                 |
| `immudb.autoscaling.targetMemory`              | Target Memory utilization percentage                                                                                                                | `nil`                                |
| `immudb.install.createUsers`                   | Boolean to specify if you want to create user after install                                                                                         | `true`                               |
| `immudb.install.secretName`                    | Secrets for hook to connect immudb                                                                                                                  | `hook-secret`                        |
| `immudb.install.hookImage.registry`            | hookImage registry                                                                                                                                  | `ghcr.io`                            |
| `immudb.install.hookImage.repository`          | hookImage repository                                                                                                                                | `datakaveri/immudb-config-generator` |
| `immudb.install.hookImage.tag`                 | hookImage tag (immutable tags are recommended)                                                                                                      | `1.4.0`                            |
| `immudb.install.hookEnvFile`                       | Hooks env File to pass on.                                                                                                                               | `nil`                                |


### Traffic Exposure Parameters

| Name                               | Description                                                                                                                      | Value                    |
| ---------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `service.type`                     | immudbs ervice type                                                                                                              | `ClusterIP`              |
| `service.ports`                    | immudb service port                                                                                                              | `nil`                    |
| `service.clusterIP`                | ApiServer service Cluster IP                                                                                                     | `None`                   |
| `service.loadBalancerIP`           | immudb service Load Balancer IP                                                                                                  | `nil`                    |
| `service.loadBalancerSourceRanges` | service Load Balancer sources                                                                                                    | `[]`                     |
| `service.externalTrafficPolicy`    | service external traffic policy                                                                                                  | `Cluster`                |
| `service.annotations`              | Additional custom annotations for service                                                                                        | `{}`                     |
| `service.extraPorts`               | Extra ports to expose in service (normally used with the `sidecars` value)                                                       | `[]`                     |
| `ingress.enabled`                  | Enable ingress record generation for %%MAIN_CONTAINER_NAME%%                                                                     | `false`                  |
| `ingress.pathType`                 | Ingress path type                                                                                                                | `ImplementationSpecific` |
| `ingress.apiVersion`               | Force Ingress API version (automatically detected if not set)                                                                    | `nil`                    |
| `ingress.hostname`                 | Default host for the ingress record                                                                                              | `""`                     |
| `ingress.path`                     | Default path for the ingress record                                                                                              | `/`                      |
| `ingress.annotations`              | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}`                     |
| `ingress.serviceName`              | Backend ingress Service Name                                                                                                     | `""`                     |
| `ingress.tls`                      | Enable TLS configuration for the host defined at `ingress.hostname` parameter                                                    | `nil`                    |
| `ingress.selfSigned`               | Create a TLS secret for this ingress record using self-signed certificates generated by Helm                                     | `false`                  |
| `ingress.extraHosts`               | An array with additional hostname(s) to be covered with the ingress record                                                       | `[]`                     |
| `ingress.extraPaths`               | An array with additional arbitrary paths that may need to be added to the ingress under the main host                            | `[]`                     |
| `ingress.extraTls`                 | TLS configuration for additional hostname(s) to be covered with this ingress record                                              | `[]`                     |
| `ingress.secrets`                  | Custom TLS certificates as secrets                                                                                               | `[]`                     |


### Init Container Parameters

| Name                                                   | Description                                                                                     | Value                              |
| ------------------------------------------------------ | ----------------------------------------------------------------------------------------------- | ---------------------------------- |
| `volumePermissions.enabled`                            | Enable init container that changes the owner/group of the PV mount point to `runAsUser:fsGroup` | `false`                            |
| `volumePermissions.image.registry`                     | Bitnami Shell image registry                                                                    | `docker.io`                        |
| `volumePermissions.image.repository`                   | Bitnami Shell image repository                                                                  | `bitnami/bitnami-shell`            |
| `volumePermissions.image.tag`                          | Bitnami Shell image tag (immutable tags are recommended)                                        | `10-debian-10-r%%IMAGE_REVISION%%` |
| `volumePermissions.image.pullPolicy`                   | Bitnami Shell image pull policy                                                                 | `IfNotPresent`                     |
| `volumePermissions.image.pullSecrets`                  | Bitnami Shell image pull secrets                                                                | `[]`                               |
| `volumePermissions.resources.limits`                   | The resources limits for the init container                                                     | `{}`                               |
| `volumePermissions.resources.requests`                 | The requested resources for the init container                                                  | `{}`                               |
| `volumePermissions.containerSecurityContext.runAsUser` | Set init container's Security Context runAsUser                                                 | `0`                                |


### Other Parameters

| Name                         | Description                                          | Value  |
| ---------------------------- | ---------------------------------------------------- | ------ |
| `serviceAccount.create`      | Specifies whether a ServiceAccount should be created | `true` |
| `serviceAccount.annotations` | Annotations to add to the service account            | `{}`   |
| `serviceAccount.name`        | The name of the ServiceAccount to use.               | `""`   |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install immudb immudb \
  --set=slack.channel="#bots",slack.token="XXXX-XXXX-XXXX"
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
helm install immudb -f values.yaml immudb/
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.


### Adding extra environment variables

In case you want to add extra environment variables (useful for advanced operations like custom init scripts), you can use the `extraEnvVars` property.

```yaml
extraEnvVars:
  - name: LOG_LEVEL
    value: DEBUG
```

Alternatively, you can use a ConfigMap or a Secret with the environment variables. To do so, use the `extraEnvVarsCM` or the `extraEnvVarsSecret` values.

### Sidecars and Init Containers

If you have a need for additional containers to run within the same pod (e.g. an additional metrics or logging exporter), you can do so via the `sidecars` config parameter. Simply define your container according to the Kubernetes container spec.

```yaml
sidecars:
  - name: your-image-name
    image: your-image
    imagePullPolicy: Always
    ports:
      - name: portname
       containerPort: 1234
```

Similarly, you can add extra init containers using the `initContainers` parameter.

```yaml
initContainers:
  - name: your-image-name
    image: your-image
    imagePullPolicy: Always
    ports:
      - name: portname
        containerPort: 1234
```

### Deploying extra resources

There are cases where you may want to deploy extra objects, such a ConfigMap containing your app's configuration or some extra deployment with a micro service used by your app. For covering this case, the chart allows adding the full specification of other objects using the `extraDeploy` parameter.

### Setting Pod's affinity

This chart allows you to set your custom affinity using the `affinity` parameter. Find more information about Pod's affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

## Troubleshooting

Find more information about how to deal with common errors related to Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).


