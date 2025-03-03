[![Kubescape Status](https://img.shields.io/jenkins/build?jobUrl=https%3A%2F%2Fjenkins.iudx.io%2Fjob%2Fkubescape-lip%2F&label=Kubescape)](https://jenkins.iudx.io/job/kubescape-lip/lastBuild/Kubescape_20Scan_20Report_20for_20LIP/)


## Introduction

Helm Chart for IUDX latest-ingestion-pipeline Server Deployment

## Create secret files

Make a copy of sample secrets directory and add appropriate values to all files.

```console
 cp -r example-secrets/secrets .
```

```
# secrets directory after generation of secret files
secrets/
├── .lip.env
├── attribute-mapping.json
└── config.json
```

## Define Appropriate values of resources

Define Appropriate values of resources -
- CPU of all latest-ingestion-pipeline verticles
- RAM of all latest-ingestion-pipeline verticles
in `resource-values.yaml` as shown in sample resource-values file for [`aws`](./example-aws-resource-values.yaml) and [`azure`](./example-azure-resource-values.yaml)

## Installing the Chart

To install the `latest-ingestion-pipeline`chart:

```console
 ./install.sh
```

The command deploys  resource-server on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

Following script will create :
1. create a namespace `lip`
2. create required configmaps
3. create corresponding K8s secrets from the secret files
4. deploy all latest-ingestion-pipeline verticles 

## Uninstalling the Chart

To uninstall/delete the `latest-ingestion-pipeline` deployment:

```console
 helm delete latest-ingestion-pipeline -n lip
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
| `nameSpace`              | Namespace to deploy the controller                                                      | `lip`           |
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

| Name                        | Description                                | Value                 |
| --------------------------- | ------------------------------------------ | --------------------- |
| `image.registry`            | image registry                             | `ghcr.io`             |
| `image.repository`          | image repository                           | `datakaveri/lip-depl` |
| `image.tag`                 | image tag (immutable tags are recommended) | `3.0-b803449`         |
| `image.pullPolicy`          | image pull policy                          | `IfNotPresent`        |
| `image.pullSecrets`         | image pull secrets                         | `{}`                  |
| `image.debug`               | Enable image debug mode                    | `false`               |
| `containerPorts.http`       | HTTP container port                        | `80`                  |
| `containerPorts.https`      | HTTPS container port                       | `443`                 |
| `containerPorts.hazelcast`  | Hazelcast container port                   | `5701`                |
| `containerPorts.prometheus` | Prometheus container port                  | `9000`                |
| `podAnnotations`            | Annotations for pods                       | `nil`                 |


### lip Parameters

| Name                                              | Description                                                                                         | Value                                                                                                                                                                                                                 |
| ------------------------------------------------- | --------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `lip.replicaCount`                          | Number of lip replicas to deploy                                                              | `1`                                                                                                                                                                                                                   |
| `lip.livenessProbe.enabled`                 | Enable livenessProbe on lip containers                                                        | `true`                                                                                                                                                                                                                |
| `lip.livenessProbe.initialDelaySeconds`     | Initial delay seconds for livenessProbe                                                             | `60`                                                                                                                                                                                                                  |
| `lip.livenessProbe.periodSeconds`           | Period seconds for livenessProbe                                                                    | `60`                                                                                                                                                                                                                  |
| `lip.livenessProbe.timeoutSeconds`          | Timeout seconds for livenessProbe                                                                   | `10`                                                                                                                                                                                                                  |
| `lip.livenessProbe.failureThreshold`        | Failure threshold for livenessProbe                                                                 | `10`                                                                                                                                                                                                                  |
| `lip.livenessProbe.successThreshold`        | Success threshold for livenessProbe                                                                 | `10`                                                                                                                                                                                                                  |
| `lip.livenessProbe.path`                    | Path for httpGet                                                                                    | `/metrics`                                                                                                                                                                                                            |
| `lip.readinessProbe.enabled`                | Enable readinessProbe on lip containers                                                       | `false`                                                                                                                                                                                                               |
| `lip.readinessProbe.initialDelaySeconds`    | Initial delay seconds for readinessProbe                                                            | `10`                                                                                                                                                                                                                  |
| `lip.readinessProbe.periodSeconds`          | Period seconds for readinessProbe                                                                   | `10`                                                                                                                                                                                                                  |
| `lip.readinessProbe.timeoutSeconds`         | Timeout seconds for readinessProbe                                                                  | `10`                                                                                                                                                                                                                  |
| `lip.readinessProbe.failureThreshold`       | Failure threshold for readinessProbe                                                                | `10`                                                                                                                                                                                                                  |
| `lip.readinessProbe.successThreshold`       | Success threshold for readinessProbe                                                                | `10`                                                                                                                                                                                                                  |
| `lip.startupProbe.enabled`                  | Enable startupProbe on lip containers                                                         | `false`                                                                                                                                                                                                               |
| `lip.startupProbe.initialDelaySeconds`      | Initial delay seconds for startupProbe                                                              | `10`                                                                                                                                                                                                                  |
| `lip.startupProbe.periodSeconds`            | Period seconds for startupProbe                                                                     | `10`                                                                                                                                                                                                                  |
| `lip.startupProbe.timeoutSeconds`           | Timeout seconds for startupProbe                                                                    | `10`                                                                                                                                                                                                                  |
| `lip.startupProbe.failureThreshold`         | Failure threshold for startupProbe                                                                  | `10`                                                                                                                                                                                                                  |
| `lip.startupProbe.successThreshold`         | Success threshold for startupProbe                                                                  | `10`                                                                                                                                                                                                                  |
| `lip.customLivenessProbe`                   | Custom livenessProbe that overrides the default one                                                 | `{}`                                                                                                                                                                                                                  |
| `lip.customReadinessProbe`                  | Custom readinessProbe that overrides the default one                                                | `{}`                                                                                                                                                                                                                  |
| `lip.customStartupProbe`                    | Custom startupProbe that overrides the default one                                                  | `{}`                                                                                                                                                                                                                  |
| `lip.resources.limits`                      | The resources limits for the lip containers                                                   | `{}`                                                                                                                                                                                                                  |
| `lip.resources.requests`                    | The requested resources for the lip containers                                                | `{}`                                                                                                                                                                                                                  |
| `lip.podSecurityContext.enabled`            | Enabled lip pods' Security Context                                                            | `false`                                                                                                                                                                                                               |
| `lip.podSecurityContext.fsGroup`            | Set lip pod's Security Context fsGroup                                                        | `1001`                                                                                                                                                                                                                |
| `lip.containerSecurityContext.enabled`      | Enabled lip containers' Security Context                                                      | `false`                                                                                                                                                                                                               |
| `lip.containerSecurityContext.runAsUser`    | Set lip containers' Security Context runAsUser                                                | `1001`                                                                                                                                                                                                                |
| `lip.containerSecurityContext.runAsNonRoot` | Set lip containers' Security Context runAsNonRoot                                             | `true`                                                                                                                                                                                                                |
| `lip.existingConfigmap`                     | The name of an existing ConfigMap with your custom configuration for lip                      | `nil`                                                                                                                                                                                                                 |
| `lip.command`                               | Override default container command (useful when using custom images)                                | `["/bin/bash"]`                                                                                                                                                                                                       |
| `lip.args`                                  | Override default container args (useful when using custom images)                                   | `["-c","exec java -Xmx1024m -Dvertx.logger-delegate-factory-class-name=io.vertx.core.logging.Log4j2LogDelegateFactory  -jar ./fatjar.jar  --host $$MY_POD_IP -c secrets/one-verticle-configs/config-lip.json"]` |
| `lip.hostAliases`                           | redis pods host aliases                                                                             | `[]`                                                                                                                                                                                                                  |
| `lip.podLabels`                             | Extra labels for lip pods                                                                     | `{}`                                                                                                                                                                                                                  |
| `lip.podAffinityPreset`                     | Pod affinity preset. Ignored if `lip.affinity` is set. Allowed values: `soft` or `hard`       | `""`                                                                                                                                                                                                                  |
| `lip.podAntiAffinityPreset`                 | Pod anti-affinity preset. Ignored if `lip.affinity` is set. Allowed values: `soft` or `hard`  | `""`                                                                                                                                                                                                                  |
| `lip.nodeAffinityPreset.type`               | Node affinity preset type. Ignored if `lip.affinity` is set. Allowed values: `soft` or `hard` | `""`                                                                                                                                                                                                                  |
| `lip.nodeAffinityPreset.key`                | Node label key to match. Ignored if `lip.affinity` is set                                     | `""`                                                                                                                                                                                                                  |
| `lip.nodeAffinityPreset.values`             | Node label values to match. Ignored if `lip.affinity` is set                                  | `[]`                                                                                                                                                                                                                  |
| `lip.affinity`                              | Affinity for lip pods assignment                                                              | `{}`                                                                                                                                                                                                                  |
| `lip.nodeSelector`                          | Node labels for lip pods assignment                                                           | `nil`                                                                                                                                                                                                                 |
| `lip.tolerations`                           | Tolerations for lip pods assignment                                                           | `[]`                                                                                                                                                                                                                  |
| `lip.updateStrategy.type`                   | lip statefulset strategy type                                                                 | `RollingUpdate`                                                                                                                                                                                                       |
| `lip.priorityClassName`                     | lip pods' priorityClassName                                                                   | `""`                                                                                                                                                                                                                  |
| `lip.schedulerName`                         | Name of the k8s scheduler (other than default) for lip pods                                   | `""`                                                                                                                                                                                                                  |
| `lip.lifecycleHooks`                        | for the lip container(s) to automate configuration before or after startup                    | `{}`                                                                                                                                                                                                                  |
| `lip.extraEnvVars`                          | Array with extra environment variables to add to lip nodes                                    | `[]`                                                                                                                                                                                                                  |
| `lip.extraEnvVarsCM`                        | Name of existing ConfigMap containing extra env vars for lip nodes                            | `lip-env`                                                                                                                                                                                                             |
| `lip.extraEnvVarsSecret`                    | Name of existing Secret containing extra env vars for lip nodes                               | `nil`                                                                                                                                                                                                                 |
| `lip.extraVolumes`                          | Optionally specify extra list of additional volumes for the lip pod(s)                        | `nil`                                                                                                                                                                                                                 |
| `lip.extraVolumeMounts`                     | Optionally specify extra list of additional volumeMounts for the lip container(s)             | `nil`                                                                                                                                                                                                                 |
| `lip.sidecars`                              | Add additional sidecar containers to the lip pod(s)                                           | `{}`                                                                                                                                                                                                                  |
| `lip.initContainers`                        | Add additional init containers to the lip pod(s)                                              | `{}`                                                                                                                                                                                                                  |
| `lip.autoscaling.enabled`                   | Enable Horizontal POD autoscaling for Apache                                                        | `true`                                                                                                                                                                                                                |
| `lip.autoscaling.minReplicas`               | Minimum number of Apache replicas                                                                   | `1`                                                                                                                                                                                                                   |
| `lip.autoscaling.maxReplicas`               | Maximum number of Apache replicas                                                                   | `5`                                                                                                                                                                                                                   |
| `lip.autoscaling.targetCPU`                 | Target CPU utilization percentage                                                                   | `80`                                                                                                                                                                                                                  |
| `lip.autoscaling.targetMemory`              | Target Memory utilization percentage                                                                | `nil`                                                                                                                                                                                                                 |




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
 helm install latest-ingestion-pipeline latest-ingestion-pipeline \
  --set=slack.channel="#bots",slack.token="XXXX-XXXX-XXXX"
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
 helm install latest-ingestion-pipeline -f values.yaml latest-ingestion-pipeline/
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


