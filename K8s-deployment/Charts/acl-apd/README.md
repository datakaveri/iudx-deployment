## Introduction

Helm Chart for IUDX Acl-Apd-server Server Deployment

## Create secret files

Make a copy of sample secrets directory and add appropriate values to all files.

```console
 cp -r example-secrets/* .
```

```
# secrets directory after generation of secret files
secrets/
├── .apd.env
└── config.json
```

## Define Appropriate values of resources

Define Appropriate values of resources -
- CPU of all Acl-Apd-server verticles
- RAM of all Acl-Apd-server verticles

in `resource-values.yaml` as shown in sample resource-values Acl-Apd for [`aws`](./example-aws-resource-values.yaml) and [`azure`](./example-azure-resource-values.yaml)

## Installing the Chart

To install the `acl-apd-server` chart:

```console
 ./install.sh
```

The command deploys  resource-server on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

Following script will create :
1. create a namespace `acl-apd`
2. create required configmaps
3. create corresponding K8s secrets from the secret files
4. deploy all acl-apd-server verticles 


## Uninstalling the Chart

To uninstall/delete the `acl-apd-server` deployment:

```console
 helm delete acl-apd -n acl-apd
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
| `nameSpace`              | Namespace to deploy the controller                                                      | `acl-apd`           |
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
| `image.repository`          | image repository                           | `datakaveri/acl-apd-depl` |
| `image.tag`                 | image tag (immutable tags are recommended) | `5.0.0-alpha-66870e9`        |
| `image.pullPolicy`          | image pull policy                          | `IfNotPresent`       |
| `image.pullSecrets`         | image pull secrets                         | `{}`                 |
| `image.debug`               | Enable image debug mode                    | `false`              |
| `containerPorts.http`       | HTTP container port                        | `8080`                 |
| `containerPorts.https`      | HTTPS container port                       | `8443`                |
| `containerPorts.hazelcast`  | Hazelcast container port                   | `5701`               |
| `containerPorts.prometheus` | Prometheus container port                  | `9000`               |
| `podAnnotations`            | Annotations for pods                       | `nil`                |

### aclApd Parameters

| Name                                             | Description                                                                                        | Value                                                                                                                                                                                                                |
| ------------------------------------------------ | -------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `aclApd.replicaCount`                          | Number of aclApd replicas to deploy                                                              | `1`                                                                                                                                                                                                                  |
| `aclApd.livenessProbe.enabled`                 | Enable livenessProbe on aclApd containers                                                        | `true`                                                                                                                                                                                                               |
| `aclApd.livenessProbe.initialDelaySeconds`     | Initial delay seconds for livenessProbe                                                            | `60`                                                                                                                                                                                                                 |
| `aclApd.livenessProbe.periodSeconds`           | Period seconds for livenessProbe                                                                   | `60`                                                                                                                                                                                                                 |
| `aclApd.livenessProbe.timeoutSeconds`          | Timeout seconds for livenessProbe                                                                  | `10`                                                                                                                                                                                                                 |
| `aclApd.livenessProbe.failureThreshold`        | Failure threshold for livenessProbe                                                                | `10`                                                                                                                                                                                                                 |
| `aclApd.livenessProbe.successThreshold`        | Success threshold for livenessProbe                                                                | `10`                                                                                                                                                                                                                 |
| `aclApd.livenessProbe.path`                    | Path for httpGet                                                                                   | `/metrics`                                                                                                                                                                                                           |
| `aclApd.readinessProbe.enabled`                | Enable readinessProbe on aclApd containers                                                       | `false`                                                                                                                                                                                                              |
| `aclApd.readinessProbe.initialDelaySeconds`    | Initial delay seconds for readinessProbe                                                           | `10`                                                                                                                                                                                                                 |
| `aclApd.readinessProbe.periodSeconds`          | Period seconds for readinessProbe                                                                  | `10`                                                                                                                                                                                                                 |
| `aclApd.readinessProbe.timeoutSeconds`         | Timeout seconds for readinessProbe                                                                 | `10`                                                                                                                                                                                                                 |
| `aclApd.readinessProbe.failureThreshold`       | Failure threshold for readinessProbe                                                               | `10`                                                                                                                                                                                                                 |
| `aclApd.readinessProbe.successThreshold`       | Success threshold for readinessProbe                                                               | `10`                                                                                                                                                                                                                 |
| `aclApd.startupProbe.enabled`                  | Enable startupProbe on aclApd containers                                                         | `false`                                                                                                                                                                                                              |
| `aclApd.startupProbe.initialDelaySeconds`      | Initial delay seconds for startupProbe                                                             | `10`                                                                                                                                                                                                                 |
| `aclApd.startupProbe.periodSeconds`            | Period seconds for startupProbe                                                                    | `10`                                                                                                                                                                                                                 |
| `aclApd.startupProbe.timeoutSeconds`           | Timeout seconds for startupProbe                                                                   | `10`                                                                                                                                                                                                                 |
| `aclApd.startupProbe.failureThreshold`         | Failure threshold for startupProbe                                                                 | `10`                                                                                                                                                                                                                 |
| `aclApd.startupProbe.successThreshold`         | Success threshold for startupProbe                                                                 | `10`                                                                                                                                                                                                                 |
| `aclApd.customLivenessProbe`                   | Custom livenessProbe that overrides the default one                                                | `{}`                                                                                                                                                                                                                 |
| `aclApd.customReadinessProbe`                  | Custom readinessProbe that overrides the default one                                               | `{}`                                                                                                                                                                                                                 |
| `aclApd.customStartupProbe`                    | Custom startupProbe that overrides the default one                                                 | `{}`                                                                                                                                                                                                                 |
| `aclApd.resources.limits`                      | The resources limits for the aclApd containers                                                   | `nil`                                                                                                                                                                                                                |
| `aclApd.resources.requests`                    | The requested resources for the aclApd containers                                                | `nil`                                                                                                                                                                                                                |
| `aclApd.podSecurityContext.enabled`            | Enabled aclApd pods' Security Context                                                            | `false`                                                                                                                                                                                                              |
| `aclApd.podSecurityContext.fsGroup`            | Set aclApd pod's Security Context fsGroup                                                        | `1001`                                                                                                                                                                                                               |
| `aclApd.containerSecurityContext.enabled`      | Enabled aclApd containers' Security Context                                                      | `false`                                                                                                                                                                                                              |
| `aclApd.containerSecurityContext.runAsUser`    | Set aclApd containers' Security Context runAsUser                                                | `1001`                                                                                                                                                                                                               |
| `aclApd.containerSecurityContext.runAsNonRoot` | Set aclApd containers' Security Context runAsNonRoot                                             | `true`                                                                                                                                                                                                               |
| `aclApd.existingConfigmap`                     | The name of an existing ConfigMap with your custom configuration for aclApd                      | `nil`                                                                                                                                                                                                                |
| `aclApd.command`                               | Override default container command (useful when using custom images)                               | `["/bin/bash"]`                                                                                                                                                                                                      |
| `aclApd.args`                                  | Override default container args (useful when using custom images)                                  | `["-c","exec java $$APD_JAVA_OPTS -Dvertx.logger-delegate-factory-class-name=io.vertx.core.logging.Log4j2LogDelegateFactory -jar ./fatjar.jar --host $$(hostname) -c secrets/configs/config.json"]` |
| `aclApd.hostAliases`                           | aclApd pods host aliases                                                                         | `[]`                                                                                                                                                                                                                 |
| `aclApd.podLabels`                             | Extra labels for aclApd pods                                                                     | `{}`                                                                                                                                                                                                                 |
| `aclApd.podAffinityPreset`                     | Pod affinity preset. Ignored if `aclApd.affinity` is set. Allowed values: `soft` or `hard`       | `""`                                                                                                                                                                                                                 |
| `aclApd.podAntiAffinityPreset`                 | Pod anti-affinity preset. Ignored if `aclApd.affinity` is set. Allowed values: `soft` or `hard`  | `""`                                                                                                                                                                                                                 |
| `aclApd.nodeAffinityPreset.type`               | Node affinity preset type. Ignored if `aclApd.affinity` is set. Allowed values: `soft` or `hard` | `""`                                                                                                                                                                                                                 |
| `aclApd.nodeAffinityPreset.key`                | Node label key to match. Ignored if `aclApd.affinity` is set                                     | `""`                                                                                                                                                                                                                 |
| `aclApd.nodeAffinityPreset.values`             | Node label values to match. Ignored if `aclApd.affinity` is set                                  | `[]`                                                                                                                                                                                                                 |
| `aclApd.affinity`                              | Affinity for aclApd pods assignment                                                              | `{}`                                                                                                                                                                                                                 |
| `aclApd.nodeSelector`                          | Node labels for aclApd pods assignment                                                           | `nil`                                                                                                                                                                                                                |
| `aclApd.tolerations`                           | Tolerations for aclApd pods assignment                                                           | `[]`                                                                                                                                                                                                                 |
| `aclApd.updateStrategy.type`                   | aclApd statefulset strategy type                                                                 | `RollingUpdate`                                                                                                                                                                                                      |
| `aclApd.priorityClassName`                     | aclApd pods' priorityClassName                                                                   | `""`                                                                                                                                                                                                                 |
| `aclApd.schedulerName`                         | Name of the k8s scheduler (other than default) for aclApd pods                                   | `""`                                                                                                                                                                                                                 |
| `aclApd.lifecycleHooks`                        | for the aclApd container(s) to automate configuration before or after startup                    | `{}`                                                                                                                                                                                                                 |
| `aclApd.extraEnvVars`                          | Array with extra environment variables to add to aclApd nodes                                    | `[]`                                                                                                                                                                                                                 |
| `aclApd.extraEnvVarsCM`                        | Name of existing ConfigMap containing extra env vars for aclApd nodes                            | `apd-env`                                                                                                                                                                                                            |
| `aclApd.extraEnvVarsSecret`                    | Name of existing Secret containing extra env vars for aclApd nodes                               | `nil`                                                                                                                                                                                                                |
| `aclApd.extraVolumes`                          | Optionally specify extra list of additional volumes for the aclApd pod(s)                        | `nil`                                                                                                                                                                                                                |
| `aclApd.extraVolumeMounts`                     | Optionally specify extra list of additional volumeMounts for the aclApd container(s)             | `nil`                                                                                                                                                                                                                |
| `aclApd.sidecars`                              | Add additional sidecar containers to the aclApd pod(s)                                           | `{}`                                                                                                                                                                                                                 |
| `aclApd.initContainers`                        | Add additional init containers to the aclApd pod(s)                                              | `{}`                                                                                                                                                                                                                 |
| `aclApd.autoscaling.enabled`                   | Enable Horizontal POD autoscaling for Apache                                                       | `false`                                                                                                                                                                                                              |
| `aclApd.autoscaling.minReplicas`               | Minimum number of Apache replicas                                                                  | `1`                                                                                                                                                                                                                  |
| `aclApd.autoscaling.maxReplicas`               | Maximum number of Apache replicas                                                                  | `5`                                                                                                                                                                                                                  |
| `aclApd.autoscaling.targetCPU`                 | Target CPU utilization percentage                                                                  | `80`                                                                                                                                                                                                                 |
| `aclApd.autoscaling.targetMemory`              | Target Memory utilization percentage                                                               | `nil`          


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
 helm install acl-apd-server acl-apd-server \
  --set=slack.channel="#bots",slack.token="XXXX-XXXX-XXXX"
```

Alternatively, a YAML acl-apd that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
 helm install acl-apd-server -f values.yaml acl-apd-server/
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

