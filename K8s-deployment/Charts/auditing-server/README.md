[![Kubescape Status](https://img.shields.io/jenkins/build?jobUrl=https%3A%2F%2Fjenkins.iudx.io%2Fjob%2Fkubescape-auditing%2F&label=Kubescape)](https://jenkins.iudx.io/job/kubescape-auditing/lastBuild/Kubescape_20Scan_20Report_20for_20Auditing_20Server/)

## Introduction

Helm Chart for IUDX auditing-server Server Deployment

## Create secret files

Make a copy of sample secrets directory and add appropriate values to all files.

```console
 cp -r example-secrets/* .
```

```
# secrets directory after generation of secret files
secrets/
├── .auditing.env
└── config.json
```

## Define Appropriate values of resources

Define Appropriate values of resources -
- CPU of all auditing-server verticles
- RAM of all auditing-server verticles

in `resource-values.yaml` as shown in sample resource-values auditing for [`aws`](./example-aws-resource-values.yaml) and [`azure`](./example-azure-resource-values.yaml)

## Installing the Chart

To install the `auditing-server`chart:

```console
 ./install.sh
```

The command deploys  resource-server on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

Following script will create :
1. create a namespace `auditing`
2. create required configmaps
3. create corresponding K8s secrets from the secret files
4. deploy all auditing-server verticles 


## Uninstalling the Chart

To uninstall/delete the `auditing-server` deployment:

```console
 helm delete auditing-server -n auditing
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
| ------------------------ | --------------------------------------------------------------------------------------- | --------------- |
| `nameSpace`              | Namespace to deploy the controller                                                      | `auditing`           |
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
| `image.repository`          | image repository                           | `datakaveri/auditing-server-depl` |
| `image.tag`                 | image tag (immutable tags are recommended) | `3.0-2a93bdf`        |
| `image.pullPolicy`          | image pull policy                          | `IfNotPresent`       |
| `image.pullSecrets`         | image pull secrets                         | `{}`                 |
| `image.debug`               | Enable image debug mode                    | `false`              |
| `containerPorts.http`       | HTTP container port                        | `8080`                 |
| `containerPorts.https`      | HTTPS container port                       | `8443`                |
| `containerPorts.hazelcast`  | Hazelcast container port                   | `5701`               |
| `containerPorts.prometheus` | Prometheus container port                  | `9000`               |
| `podAnnotations`            | Annotations for pods                       | `nil`                |


### auditingServer Parameters

| Name                                              | Description                                                                                                                                            | Value                                                                                                                                                                                                                |
| ------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `auditingServer.replicaCount`                          | Number of auditingServer replicas to deploy                                                                                                                 | `1`                                                                                                                                                                                                                  |
| `auditingServer.livenessProbe.enabled`                 | Enable livenessProbe on auditingServer containers                                                                                                           | `true`                                                                                                                                                                                                               |
| `auditingServer.livenessProbe.initialDelaySeconds`     | Initial delay seconds for livenessProbe                                                                                                                | `60`                                                                                                                                                                                                                 |
| `auditingServer.livenessProbe.periodSeconds`           | Period seconds for livenessProbe                                                                                                                       | `60`                                                                                                                                                                                                                 |
| `auditingServer.livenessProbe.timeoutSeconds`          | Timeout seconds for livenessProbe                                                                                                                      | `10`                                                                                                                                                                                                                 |
| `auditingServer.livenessProbe.failureThreshold`        | Failure threshold for livenessProbe                                                                                                                    | `10`                                                                                                                                                                                                                 |
| `auditingServer.livenessProbe.successThreshold`        | Success threshold for livenessProbe                                                                                                                    | `10`                                                                                                                                                                                                                 |
| `auditingServer.livenessProbe.path`                    | Path for httpGet                                                                                                                                       | `/metrics`                                                                                                                                                                                                           |
| `auditingServer.readinessProbe.enabled`                | Enable readinessProbe on auditingServer containers                                                                                                          | `false`                                                                                                                                                                                                              |
| `auditingServer.readinessProbe.initialDelaySeconds`    | Initial delay seconds for readinessProbe                                                                                                               | `10`                                                                                                                                                                                                                 |
| `auditingServer.readinessProbe.periodSeconds`          | Period seconds for readinessProbe                                                                                                                      | `10`                                                                                                                                                                                                                 |
| `auditingServer.readinessProbe.timeoutSeconds`         | Timeout seconds for readinessProbe                                                                                                                     | `10`                                                                                                                                                                                                                 |
| `auditingServer.readinessProbe.failureThreshold`       | Failure threshold for readinessProbe                                                                                                                   | `10`                                                                                                                                                                                                                 |
| `auditingServer.readinessProbe.successThreshold`       | Success threshold for readinessProbe                                                                                                                   | `10`                                                                                                                                                                                                                 |
| `auditingServer.startupProbe.enabled`                  | Enable startupProbe on auditingServer containers                                                                                                            | `false`                                                                                                                                                                                                              |
| `auditingServer.startupProbe.initialDelaySeconds`      | Initial delay seconds for startupProbe                                                                                                                 | `10`                                                                                                                                                                                                                 |
| `auditingServer.startupProbe.periodSeconds`            | Period seconds for startupProbe                                                                                                                        | `10`                                                                                                                                                                                                                 |
| `auditingServer.startupProbe.timeoutSeconds`           | Timeout seconds for startupProbe                                                                                                                       | `10`                                                                                                                                                                                                                 |
| `auditingServer.startupProbe.failureThreshold`         | Failure threshold for startupProbe                                                                                                                     | `10`                                                                                                                                                                                                                 |
| `auditingServer.startupProbe.successThreshold`         | Success threshold for startupProbe                                                                                                                     | `10`                                                                                                                                                                                                                 |
| `auditingServer.customLivenessProbe`                   | Custom livenessProbe that overrides the default one                                                                                                    | `{}`                                                                                                                                                                                                                 |
| `auditingServer.customReadinessProbe`                  | Custom readinessProbe that overrides the default one                                                                                                   | `{}`                                                                                                                                                                                                                 |
| `auditingServer.customStartupProbe`                    | Custom startupProbe that overrides the default one                                                                                                     | `{}`                                                                                                                                                                                                                 |
| `auditingServer.resources.limits`                      | The resources limits for the auditingServer containers                                                                                                      | `nil`                                                                                                                                                                                                                |
| `auditingServer.resources.requests`                    | The requested resources for the auditingServer containers                                                                                                   | `nil`                                                                                                                                                                                                                |
| `auditingServer.podSecurityContext.enabled`            | Enabled auditingServer pods' Security Context                                                                                                               | `true`                                                                                                                                                                                                              |
| `auditingServer.podSecurityContext.fsGroup`            | Set auditingServer pod's Security Context fsGroup                                                                                                           | `1001`                                                                                                                                                                                                               |
| `auditingServer.containerSecurityContext.enabled`      | Enabled auditingServer containers' Security Context                                                                                                         | `false`                                                                                                                                                                                                              |
| `auditingServer.containerSecurityContext.runAsUser`    | Set auditingServer containers' Security Context runAsUser                                                                                                   | `1001`                                                                                                                                                                                                               |
| `auditingServer.containerSecurityContext.runAsNonRoot` | Set auditingServer containers' Security Context runAsNonRoot                                                                                                | `true`                                                                                                                                                                                                               |
| `auditingServer.existingConfigmap`                     | The name of an existing ConfigMap with your custom configuration for auditingServer                                                                         | `nil`                                                                                                                                                                                                                |
| `auditingServer.command`                               | Override default container command (useful when using custom images)                                                                                   | `["/bin/bash"]`                                                                                                                                                                                                      |
| `auditingServer.args`                                  | Override default container args (useful when using custom images)                                                                                      | `["-c","exec java -Xmx1024m -Dvertx.logger-delegate-factory-class-name=io.vertx.core.logging.Log4j2LogDelegateFactory -jar ./fatjar.jar  --host $$MY_POD_IP -c secrets/configs/config.json -m  iudx.auditing.server.rabbitmq.RabbitMqVerticle"]` |
| `auditingServer.hostAliases`                           | auditingServer pods host aliases                                                                                                                            | `[]`                                                                                                                                                                                                                 |
| `auditingServer.podLabels`                             | Extra labels for auditingServer pods                                                                                                                        | `{}`                                                                                                                                                                                                                 |
| `auditingServer.podAffinityPreset`                     | Pod affinity preset. Ignored if `auditingServer.affinity` is set. Allowed values: `soft` or `hard`                                                          | `""`                                                                                                                                                                                                                 |
| `auditingServer.podAntiAffinityPreset`                 | Pod anti-affinity preset. Ignored if `auditingServer.affinity` is set. Allowed values: `soft` or `hard`                                                     | `""`                                                                                                                                                                                                                 |
| `auditingServer.nodeAffinityPreset.type`               | Node affinity preset type. Ignored if `auditingServer.affinity` is set. Allowed values: `soft` or `hard`                                                    | `""`                                                                                                                                                                                                                 |
| `auditingServer.nodeAffinityPreset.key`                | Node label key to match. Ignored if `auditingServer.affinity` is set                                                                                        | `""`                                                                                                                                                                                                                 |
| `auditingServer.nodeAffinityPreset.values`             | Node label values to match. Ignored if `auditingServer.affinity` is set                                                                                     | `[]`                                                                                                                                                                                                                 |
| `auditingServer.affinity`                              | Affinity for auditingServer pods assignment                                                                                                                 | `{}`                                                                                                                                                                                                                 |
| `auditingServer.nodeSelector`                          | Node labels for auditingServer pods assignment                                                                                                              | `nil`                                                                                                                                                                                                                |
| `auditingServer.tolerations`                           | Tolerations for auditingServer pods assignment                                                                                                              | `[]`                                                                                                                                                                                                                 |
| `auditingServer.updateStrategy.type`                   | auditingServer statefulset strategy type                                                                                                                    | `RollingUpdate`                                                                                                                                                                                                      |
| `auditingServer.priorityClassName`                     | auditingServer pods' priorityClassName                                                                                                                      | `""`                                                                                                                                                                                                                 |
| `auditingServer.schedulerName`                         | Name of the k8s scheduler (other than default) for auditingServer pods                                                                                      | `""`                                                                                                                                                                                                                 |
| `auditingServer.lifecycleHooks`                        | for the auditingServer container(s) to automate configuration before or after startup                                                                       | `{}`                                                                                                                                                                                                                 |
| `auditingServer.extraEnvVars`                          | Array with extra environment variables to add to auditingServer nodes                                                                                       | `[]`                                                                                                                                                                                                                 |
| `auditingServer.extraEnvVarsCM`                        | Name of existing ConfigMap containing extra env vars for auditingServer nodes                                                                               | `auditing-env`                                                                                                                                                                                                             |
| `auditingServer.extraEnvVarsSecret`                    | Name of existing Secret containing extra env vars for auditingServer nodes                                                                                  | `nil`                                                                                                                                                                                                                |
| `auditingServer.extraVolumes`                          | Optionally specify extra list of additional volumes for the auditingServer pod(s)                                                                           | `nil`                                                                                                                                                                                                                |
| `auditingServer.extraVolumeMounts`                     | Optionally specify extra list of additional volumeMounts for the auditingServer container(s)                                                                | `nil`                                                                                                                                                                                                                |
| `auditingServer.sidecars`                              | Add additional sidecar containers to the auditingServer pod(s)                                                                                              | `{}`                                                                                                                                                                                                                 |
| `auditingServer.initContainers`                        | Add additional init containers to the auditingServer pod(s)                                                                                                 | `{}`                                                                                                                                                                                                                 |
| `auditingServer.autoscaling.enabled`                   | Enable Horizontal POD autoscaling for Apache                                                                                                           | `false`                                                                                                                                                                                                              |
| `auditingServer.autoscaling.minReplicas`               | Minimum number of Apache replicas                                                                                                                      | `1`                                                                                                                                                                                                                  |
| `auditingServer.autoscaling.maxReplicas`               | Maximum number of Apache replicas                                                                                                                      | `5`                                                                                                                                                                                                                  |
| `auditingServer.autoscaling.targetCPU`                 | Target CPU utilization percentage                                                                                                                      | `80`                                                                                                                                                                                                                 |
| `auditingServer.autoscaling.targetMemory`              | Target Memory utilization percentage                                                                                                                   | `nil`                                                                                                                                                                                                                |
| `auditingServer.persistence.enabled`                   | Enable persistence using a `PersistentVolumeClaim`                                                                                                     | `true`                                                                                                                                                                                                               |
| `auditingServer.persistence.storageClass`              | Persistent Volume Storage Class                                                                                                                        | `ebs-storage-class`                                                                                                                                                                                                  |
| `auditingServer.persistence.existingClaim`             | Existing Persistent Volume Claim                                                                                                                       | `""`                                                                                                                                                                                                                 |
| `auditingServer.persistence.existingVolume`            | Existing Persistent Volume for use as volume match label selector to the `volumeClaimTemplate`. Ignored when `auditingServer.persistence.selector` ist set. | `""`                                                                                                                                                                                                                 |
| `auditingServer.persistence.selector`                  | Configure custom selector for existing Persistent Volume. Overwrites `auditingServer.persistence.existingVolume`                                            | `{}`                                                                                                                                                                                                                 |
| `auditingServer.persistence.annotations`               | Persistent Volume Claim annotations                                                                                                                    | `{}`                                                                                                                                                                                                                 |
| `auditingServer.persistence.accessModes`               | Persistent Volume Access Modes                                                                                                                         | `["ReadWriteOnce"]`                                                                                                                                                                                                  |
| `auditingServer.persistence.size`                      | Persistent Volume Size                                                                                                                                 | `8Gi`                                                                                                                                                                                                                |


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
 helm install auditing-server auditing-server \
  --set=slack.channel="#bots",slack.token="XXXX-XXXX-XXXX"
```

Alternatively, a YAML auditing that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
 helm install auditing-server -f values.yaml auditing-server/
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
