[![Kubescape Status](https://img.shields.io/jenkins/build?jobUrl=https%3A%2F%2Fjenkins.iudx.io%2Fjob%2Fkubescape-fs%2F&label=Kubescape)](https://jenkins.iudx.io/job/kubescape-fs/lastBuild/Kubescape_20Scan_20Report_20for_20FS/)

## Introduction

Helm Chart for IUDX file-server Server Deployment


## Create secret files

Make a copy of sample secrets directory and add appropriate values to all files.

```console
 cp -r example-secrets/* .
```

```
# secrets directory after generation of secret files
secrets/
├── .fs.env
└── config.json
```

## Define Appropriate values of resources

Define Appropriate values of resources -
- CPU of all file-server verticles
- RAM of all file-server verticles
- ingress.hostname
- cert-manager issuer

in `resource-values.yaml` as shown in sample resource-values file for [`aws`](./example-aws-resource-values.yaml) and [`azure`](./example-azure-resource-values.yaml)

## Installing the Chart

To install the `file-server`chart:

```console
 ./install.sh
```

The command deploys  resource-server on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

Following script will create :
1. create a namespace `fs`
2. create required configmaps
3. create corresponding K8s secrets from the secret files
4. deploy all file-server verticles 

### To create ingress redirect to cos url:
```console
kubectl apply -f ../../misc/redirect-fs-ingress.yaml -n fs
```

## Uninstalling the Chart

To uninstall/delete the `file-server` deployment:

```console
 helm delete file-server -n fs
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

### Global parameters

| Name                      | Description                                     | Value |
| ------------------------- | ----------------------------------------------- | ----- |
| `global.imageRegistry`    | Global Docker image registry                    | `""`  |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]`  |
| `global.storageClass`     | Global StorageClass for Persistent Volume(s)    | `""`  |


### Common parameters

| Name                     | Description                                                                             | Value           |
| ------------------------ | --------------------------------------------------------------------------------------- | --------------- |         |
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

| Name                        | Description                                | Value                |
| --------------------------- | ------------------------------------------ | -------------------- |
| `image.registry`            | image registry                             | `ghcr.io`            |
| `image.repository`          | image repository                           | `datakaveri/fs-depl` |
| `image.tag`                 | image tag (immutable tags are recommended) | `3.0-2a93bdf`        |
| `image.pullPolicy`          | image pull policy                          | `IfNotPresent`       |
| `image.pullSecrets`         | image pull secrets                         | `{}`                 |
| `image.debug`               | Enable image debug mode                    | `false`              |
| `containerPorts.http`       | HTTP container port                        | `8080`                 |
| `containerPorts.https`      | HTTPS container port                       | `8443`                |
| `containerPorts.hazelcast`  | Hazelcast container port                   | `5701`               |
| `containerPorts.prometheus` | Prometheus container port                  | `9000`               |
| `podAnnotations`            | Annotations for pods                       | `nil`                |


### file-server Parameters

| Name                                              | Description                                                                                                                                            | Value                                                                                                                                                                                                                |
| ------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `file-server.replicaCount`                          | Number of file-server replicas to deploy                                                                                                                 | `1`                                                                                                                                                                                                                  |
| `file-server.livenessProbe.enabled`                 | Enable livenessProbe on file-server containers                                                                                                           | `true`                                                                                                                                                                                                               |
| `file-server.livenessProbe.initialDelaySeconds`     | Initial delay seconds for livenessProbe                                                                                                                | `60`                                                                                                                                                                                                                 |
| `file-server.livenessProbe.periodSeconds`           | Period seconds for livenessProbe                                                                                                                       | `60`                                                                                                                                                                                                                 |
| `file-server.livenessProbe.timeoutSeconds`          | Timeout seconds for livenessProbe                                                                                                                      | `10`                                                                                                                                                                                                                 |
| `file-server.livenessProbe.failureThreshold`        | Failure threshold for livenessProbe                                                                                                                    | `10`                                                                                                                                                                                                                 |
| `file-server.livenessProbe.successThreshold`        | Success threshold for livenessProbe                                                                                                                    | `10`                                                                                                                                                                                                                 |
| `file-server.livenessProbe.path`                    | Path for httpGet                                                                                                                                       | `/metrics`                                                                                                                                                                                                           |
| `file-server.readinessProbe.enabled`                | Enable readinessProbe on file-server containers                                                                                                          | `false`                                                                                                                                                                                                              |
| `file-server.readinessProbe.initialDelaySeconds`    | Initial delay seconds for readinessProbe                                                                                                               | `10`                                                                                                                                                                                                                 |
| `file-server.readinessProbe.periodSeconds`          | Period seconds for readinessProbe                                                                                                                      | `10`                                                                                                                                                                                                                 |
| `file-server.readinessProbe.timeoutSeconds`         | Timeout seconds for readinessProbe                                                                                                                     | `10`                                                                                                                                                                                                                 |
| `file-server.readinessProbe.failureThreshold`       | Failure threshold for readinessProbe                                                                                                                   | `10`                                                                                                                                                                                                                 |
| `file-server.readinessProbe.successThreshold`       | Success threshold for readinessProbe                                                                                                                   | `10`                                                                                                                                                                                                                 |
| `file-server.startupProbe.enabled`                  | Enable startupProbe on file-server containers                                                                                                            | `false`                                                                                                                                                                                                              |
| `file-server.startupProbe.initialDelaySeconds`      | Initial delay seconds for startupProbe                                                                                                                 | `10`                                                                                                                                                                                                                 |
| `file-server.startupProbe.periodSeconds`            | Period seconds for startupProbe                                                                                                                        | `10`                                                                                                                                                                                                                 |
| `file-server.startupProbe.timeoutSeconds`           | Timeout seconds for startupProbe                                                                                                                       | `10`                                                                                                                                                                                                                 |
| `file-server.startupProbe.failureThreshold`         | Failure threshold for startupProbe                                                                                                                     | `10`                                                                                                                                                                                                                 |
| `file-server.startupProbe.successThreshold`         | Success threshold for startupProbe                                                                                                                     | `10`                                                                                                                                                                                                                 |
| `file-server.customLivenessProbe`                   | Custom livenessProbe that overrides the default one                                                                                                    | `{}`                                                                                                                                                                                                                 |
| `file-server.customReadinessProbe`                  | Custom readinessProbe that overrides the default one                                                                                                   | `{}`                                                                                                                                                                                                                 |
| `file-server.customStartupProbe`                    | Custom startupProbe that overrides the default one                                                                                                     | `{}`                                                                                                                                                                                                                 |
| `file-server.resources.limits`                      | The resources limits for the file-server containers                                                                                                      | `nil`                                                                                                                                                                                                                |
| `file-server.resources.requests`                    | The requested resources for the file-server containers                                                                                                   | `nil`                                                                                                                                                                                                                |
| `file-server.podSecurityContext.enabled`            | Enabled file-server pods' Security Context                                                                                                               | `true`                                                                                                                                                                                                              |
| `file-server.podSecurityContext.fsGroup`            | Set file-server pod's Security Context fsGroup                                                                                                           | `1001`                                                                                                                                                                                                               |
| `file-server.containerSecurityContext.enabled`      | Enabled file-server containers' Security Context                                                                                                         | `false`                                                                                                                                                                                                              |
| `file-server.containerSecurityContext.runAsUser`    | Set file-server containers' Security Context runAsUser                                                                                                   | `1001`                                                                                                                                                                                                               |
| `file-server.containerSecurityContext.runAsNonRoot` | Set file-server containers' Security Context runAsNonRoot                                                                                                | `true`                                                                                                                                                                                                               |
| `file-server.existingConfigmap`                     | The name of an existing ConfigMap with your custom configuration for file-server                                                                         | `nil`                                                                                                                                                                                                                |
| `file-server.command`                               | Override default container command (useful when using custom images)                                                                                   | `["/bin/bash"]`                                                                                                                                                                                                      |
| `file-server.args`                                  | Override default container args (useful when using custom images)                                                                                      | `["-c","exec java -Xmx1024m -Dvertx.logger-delegate-factory-class-name=io.vertx.core.logging.Log4j2LogDelegateFactory -jar ./fatjar.jar  --host $$MY_POD_IP -c secrets/one-verticle-configs/config-file-server.json"]` |
| `file-server.hostAliases`                           | file-server pods host aliases                                                                                                                            | `[]`                                                                                                                                                                                                                 |
| `file-server.podLabels`                             | Extra labels for file-server pods                                                                                                                        | `{}`                                                                                                                                                                                                                 |
| `file-server.podAffinityPreset`                     | Pod affinity preset. Ignored if `file-server.affinity` is set. Allowed values: `soft` or `hard`                                                          | `""`                                                                                                                                                                                                                 |
| `file-server.podAntiAffinityPreset`                 | Pod anti-affinity preset. Ignored if `file-server.affinity` is set. Allowed values: `soft` or `hard`                                                     | `""`                                                                                                                                                                                                                 |
| `file-server.nodeAffinityPreset.type`               | Node affinity preset type. Ignored if `file-server.affinity` is set. Allowed values: `soft` or `hard`                                                    | `""`                                                                                                                                                                                                                 |
| `file-server.nodeAffinityPreset.key`                | Node label key to match. Ignored if `file-server.affinity` is set                                                                                        | `""`                                                                                                                                                                                                                 |
| `file-server.nodeAffinityPreset.values`             | Node label values to match. Ignored if `file-server.affinity` is set                                                                                     | `[]`                                                                                                                                                                                                                 |
| `file-server.affinity`                              | Affinity for file-server pods assignment                                                                                                                 | `{}`                                                                                                                                                                                                                 |
| `file-server.nodeSelector`                          | Node labels for file-server pods assignment                                                                                                              | `nil`                                                                                                                                                                                                                |
| `file-server.tolerations`                           | Tolerations for file-server pods assignment                                                                                                              | `[]`                                                                                                                                                                                                                 |
| `file-server.updateStrategy.type`                   | file-server statefulset strategy type                                                                                                                    | `RollingUpdate`                                                                                                                                                                                                      |
| `file-server.priorityClassName`                     | file-server pods' priorityClassName                                                                                                                      | `""`                                                                                                                                                                                                                 |
| `file-server.schedulerName`                         | Name of the k8s scheduler (other than default) for file-server pods                                                                                      | `""`                                                                                                                                                                                                                 |
| `file-server.lifecycleHooks`                        | for the file-server container(s) to automate configuration before or after startup                                                                       | `{}`                                                                                                                                                                                                                 |
| `file-server.extraEnvVars`                          | Array with extra environment variables to add to file-server nodes                                                                                       | `[]`                                                                                                                                                                                                                 |
| `file-server.extraEnvVarsCM`                        | Name of existing ConfigMap containing extra env vars for file-server nodes                                                                               | `fs-env`                                                                                                                                                                                                             |
| `file-server.extraEnvVarsSecret`                    | Name of existing Secret containing extra env vars for file-server nodes                                                                                  | `nil`                                                                                                                                                                                                                |
| `file-server.extraVolumes`                          | Optionally specify extra list of additional volumes for the file-server pod(s)                                                                           | `nil`                                                                                                                                                                                                                |
| `file-server.extraVolumeMounts`                     | Optionally specify extra list of additional volumeMounts for the file-server container(s)                                                                | `nil`                                                                                                                                                                                                                |
| `file-server.sidecars`                              | Add additional sidecar containers to the file-server pod(s)                                                                                              | `{}`                                                                                                                                                                                                                 |
| `file-server.initContainers`                        | Add additional init containers to the file-server pod(s)                                                                                                 | `{}`                                                                                                                                                                                                                 |
| `file-server.autoscaling.enabled`                   | Enable Horizontal POD autoscaling for Apache                                                                                                           | `false`                                                                                                                                                                                                              |
| `file-server.autoscaling.minReplicas`               | Minimum number of Apache replicas                                                                                                                      | `1`                                                                                                                                                                                                                  |
| `file-server.autoscaling.maxReplicas`               | Maximum number of Apache replicas                                                                                                                      | `5`                                                                                                                                                                                                                  |
| `file-server.autoscaling.targetCPU`                 | Target CPU utilization percentage                                                                                                                      | `80`                                                                                                                                                                                                                 |
| `file-server.autoscaling.targetMemory`              | Target Memory utilization percentage                                                                                                                   | `nil`                                                                                                                                                                                                                |
| `file-server.persistence.enabled`                   | Enable persistence using a `PersistentVolumeClaim`                                                                                                     | `true`                                                                                                                                                                                                               |
| `file-server.persistence.storageClass`              | Persistent Volume Storage Class                                                                                                                        | `ebs-storage-class`                                                                                                                                                                                                  |
| `file-server.persistence.existingClaim`             | Existing Persistent Volume Claim                                                                                                                       | `""`                                                                                                                                                                                                                 |
| `file-server.persistence.existingVolume`            | Existing Persistent Volume for use as volume match label selector to the `volumeClaimTemplate`. Ignored when `file-server.persistence.selector` ist set. | `""`                                                                                                                                                                                                                 |
| `file-server.persistence.selector`                  | Configure custom selector for existing Persistent Volume. Overwrites `file-server.persistence.existingVolume`                                            | `{}`                                                                                                                                                                                                                 |
| `file-server.persistence.annotations`               | Persistent Volume Claim annotations                                                                                                                    | `{}`                                                                                                                                                                                                                 |
| `file-server.persistence.accessModes`               | Persistent Volume Access Modes                                                                                                                         | `["ReadWriteOnce"]`                                                                                                                                                                                                  |
| `file-server.persistence.size`                      | Persistent Volume Size                                                                                                                                 | `8Gi`                                                                                                                                                                                                                |



### Traffic Exposure Parameters

| Name                                       | Description                                                                                                                      | Value                    |
| ------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `service.type`                             | file-server service type                                                                                                           | `ClusterIP`              |
| `service.ports`                            | file-server service port                                                                                                           | `80`                     |
| `service.targetPorts`                      | file-server service TargetPorts port                                                                                               | `8080`                     |
| `service.clusterIP`                        | file-server service Cluster IP                                                                                                     | `nil`                    |
| `service.loadBalancerIP`                   | file-server service Load Balancer IP                                                                                               | `nil`                    |
| `service.loadBalancerSourceRanges`         | service Load Balancer sources                                                                                                    | `[]`                     |
| `service.externalTrafficPolicy`            | service external traffic policy                                                                                                  | `Cluster`                |
| `service.annotations`                      | Additional custom annotations for service                                                                                        | `{}`                     |
| `service.extraPorts`                       | Extra ports to expose in service (normally used with the `sidecars` value)                                                       | `[]`                     |
| `serviceHeadless.type`                     | file-servers serviceHeadless type                                                                                                  | `ClusterIP`              |
| `serviceHeadless.ports`                    | file-server serviceHeadlessHeadlessport                                                                                            | `80`                     |
| `serviceHeadless.targetPorts`              | file-server serviceHeadlessHeadlessTargetPorts port                                                                                | `80`                     |
| `serviceHeadless.clusterIP`                | file-server serviceHeadlessHeadless Cluster IP                                                                                     | `None`                   |
| `serviceHeadless.loadBalancerIP`           | file-server service Load Balancer IP                                                                                               | `nil`                    |
| `serviceHeadless.loadBalancerSourceRanges` | serviceHeadless Load Balancer sources                                                                                            | `[]`                     |
| `serviceHeadless.externalTrafficPolicy`    | serviceHeadless external traffic policy                                                                                          | `Cluster`                |
| `serviceHeadless.annotations`              | Additional custom annotations for serviceHeadless                                                                                | `{}`                     |
| `serviceHeadless.extraPorts`               | Extra ports to expose in serviceHeadless (normally used with the `sidecars` value)                                               | `[]`                     |
| `ingress.enabled`                          | Enable ingress record generation for %%MAIN_CONTAINER_NAME%%                                                                     | `true`                   |
| `ingress.pathType`                         | Ingress path type                                                                                                                | `ImplementationSpecific` |
| `ingress.apiVersion`                       | Force Ingress API version (automatically detected if not set)                                                                    | `nil`                    |
| `ingress.hostname`                         | Default host for the ingress record                                                                                              | `file.iudx.org.in`       |
| `ingress.path`                             | Default path for the ingress record                                                                                              | `/`                      |
| `ingress.annotations`                      | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}`                     |
| `ingress.serviceName`                      | Backend ingress Service Name                                                                                                     | `file-server`          |
| `ingress.tls.secretName`                              | TLS secret name, if certmanager is used, no need to create that secret with tls certificates else create secret using the command `kubectl create secret tls fs-tls-secret --key ./secrets/pki/privkey.pem --cert ./secrets/pki/fullchain.pem -n  fs`                                                    | `fs-tls-secret`                    |
| `ingress.selfSigned`                       | Create a TLS secret for this ingress record using self-signed certificates generated by Helm                                     | `false`                  |
| `ingress.extraHosts`                       | An array with additional hostname(s) to be covered with the ingress record                                                       | `[]`                     |
| `ingress.extraPaths`                       | An array with additional arbitrary paths that may need to be added to the ingress under the main host                            | `[]`                     |
| `ingress.extraTls`                         | TLS configuration for additional hostname(s) to be covered with this ingress record                                              | `[]`                     |
| `ingress.secrets`                          | Custom TLS certificates as secrets                                                                                               | `[]`                     |


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

| Name                    | Description                                          | Value   |
| ----------------------- | ---------------------------------------------------- | ------- |
| `rbac.create`           | Specifies whether RBAC resources should be created   | `false` |
| `serviceAccount.create` | Specifies whether a ServiceAccount should be created | `false` |
| `serviceAccount.name`   | The name of the ServiceAccount to use.               | `""`    |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
 helm install file-server file-server \
  --set=slack.channel="#bots",slack.token="XXXX-XXXX-XXXX"
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
 helm install file-server -f values.yaml file-server/
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


