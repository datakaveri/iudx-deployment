## Introduction

Helm Chart for IUDX Consent Validator Server Deployment


## Generating secrets

Make a copy of sample secrets directory:

```console
cp -r example-secrets/secrets .
```
```
# secrets directory after generation of secret files
secrets/
├── .cv.env
└── config.json
└── keystore
```
Configure the env file `.cv.env` and `config.jso`n in secret/ appropriately
## Define Appropriate values of resources

Define Appropriate values of resources -
- CPU requests and limits
- RAM requests and limits
- Instance-type for nodeSelector
- Hostname for cv

in `resource-values.yaml` as shown in sample resource-values file for [`aws`](./example-aws-resource-values.yaml) and [`azure`](./example-azure-resource-values.yaml)

## Installing the Chart

To install the `consent-validator`chart:

```console
./install.sh  
```

The command deploys  resource-server on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

Following script will create :
1. create a namespace `consent`
2. create required secrets
3. deploy consentValidator verticles


## Uninstalling the Chart

To uninstall/delete the `consent-validator` deployment:

```console
helm uninstall consent-validator -n consent-validator
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
| `image.registry`            | image registry                             | `ghcr.io`   |
| `image.repository`          | image repository                           | `datakaveri/consent-validator`       |
| `image.tag`                 | image tag (immutable tags are recommended) | `1.0.0-alpha-4b0a2bf`        |
| `image.pullPolicy`          | image pull policy                          | `IfNotPresent` |
| `image.pullSecrets`         | image pull secrets                         | `{}`           |
| `image.debug`               | Enable image debug mode                    | `false`        |
| `containerPorts.http`       | HTTP container port                        | `80`           |
| `containerPorts.hazelcast`  | Hazelcast container port                   | `5701`         |
| `containerPorts.prometheus` | Prometheus container port                  | `9000`         |
| `podAnnotations`            | Annotations for pods                       | `nil`          |


### consentValidator Parameters

| Name                                           | Description                                                                                                                                         | Value                                |
| ---------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------ |
| `consentValidator.replicaCount`                          | Number of consentValidator replicas to deploy                                                                                                                 | `1`                                  |
| `consentValidator.livenessProbe.enabled`                 | Enable livenessProbe on consentValidator containers                                                                                                           | `false`                              |
| `consentValidator.livenessProbe.initialDelaySeconds`     | Initial delay seconds for livenessProbe                                                                                                             | `60`                                 |
| `consentValidator.livenessProbe.periodSeconds`           | Period seconds for livenessProbe                                                                                                                    | `10`                                 |
| `consentValidator.livenessProbe.timeoutSeconds`          | Timeout seconds for livenessProbe                                                                                                                   | `10`                                 |
| `consentValidator.livenessProbe.failureThreshold`        | Failure threshold for livenessProbe                                                                                                                 | `10`                                 |
| `consentValidator.livenessProbe.path`                    | Path for httpGet                                                                                                                                    | `/metrics`                           |
| `consentValidator.readinessProbe.enabled`                | Enable readinessProbe on consentValidator containers                                                                                                          | `false`                              |
| `consentValidator.readinessProbe.initialDelaySeconds`    | Initial delay seconds for readinessProbe                                                                                                            | `60`                                 |
| `consentValidator.readinessProbe.periodSeconds`          | Period seconds for readinessProbe                                                                                                                   | `10`                                 |
| `consentValidator.readinessProbe.timeoutSeconds`         | Timeout seconds for readinessProbe                                                                                                                  | `10`                                 |
| `consentValidator.readinessProbe.failureThreshold`       | Failure threshold for readinessProbe                                                                                                                | `10`                                 |
| `consentValidator.readinessProbe.successThreshold`       | Success threshold for readinessProbe                                                                                                                | `10`                                 |
| `consentValidator.startupProbe.enabled`                  | Enable startupProbe on consentValidator containers                                                                                                            | `false`                              |
| `consentValidator.startupProbe.initialDelaySeconds`      | Initial delay seconds for startupProbe                                                                                                              | `10`                                 |
| `consentValidator.startupProbe.periodSeconds`            | Period seconds for startupProbe                                                                                                                     | `10`                                 |
| `consentValidator.startupProbe.timeoutSeconds`           | Timeout seconds for startupProbe                                                                                                                    | `10`                                 |
| `consentValidator.startupProbe.failureThreshold`         | Failure threshold for startupProbe                                                                                                                  | `10`                                 |
| `consentValidator.startupProbe.successThreshold`         | Success threshold for startupProbe                                                                                                                  | `10`                                 |
| `consentValidator.customLivenessProbe`                   | Custom livenessProbe that overrides the default one                                                                                                 | `nil`                                |
| `consentValidator.customReadinessProbe`                  | Custom readinessProbe that overrides the default one                                                                                                | `nil`                                |
| `consentValidator.customStartupProbe`                    | Custom startupProbe that overrides the default one                                                                                                  | `{}`                                 |
| `consentValidator.resources`                             | resource requests and limits                                                                                                                        | `{}`                                 |
| `consentValidator.podSecurityContext.enabled`            | Enabled consentValidator pods' Security Context                                                                                                               | `true`                               |
| `consentValidator.podSecurityContext.fsGroup`            | Set consentValidator pod's Security Context fsGroup                                                                                                           | `3322`                               |
| `consentValidator.podSecurityContext.runAsGroup`         | Set consentValidator pod's Security Context runAsGroup                                                                                                        | `3322`                               |
| `consentValidator.podSecurityContext.runAsUser`          | Set consentValidator pod's Security Context runAsUser                                                                                                         | `3322`                               |
| `consentValidator.containerSecurityContext.enabled`      | Enabled consentValidator containers' Security Context                                                                                                         | `false`                              |
| `consentValidator.containerSecurityContext.runAsUser`    | Set consentValidator containers' Security Context runAsUser                                                                                                   | `1001`                               |
| `consentValidator.containerSecurityContext.runAsNonRoot` | Set consentValidator containers' Security Context runAsNonRoot                                                                                                | `true`                               |
| `consentValidator.existingConfigmap`                     | The name of an existing ConfigMap with your custom configuration for consentValidator                                                                         | `nil`                                |
| `consentValidator.command`                               | Override default container command (useful when using custom images)                                                                                | `[]`                                 |
| `consentValidator.args`                                  | Override default container args (useful when using custom images)                                                                                   | `[]`                                 |
| `consentValidator.hostAliases`                           | consentValidator pods host aliases                                                                                                                            | `[]`                                 |
| `consentValidator.podLabels`                             | Extra labels for consentValidator pods                                                                                                                        | `{}`                                 |
| `consentValidator.podAffinityPreset`                     | Pod affinity preset. Ignored if `consentValidator.affinity` is set. Allowed values: `soft` or `hard`                                                          | `""`                                 |
| `consentValidator.podAntiAffinityPreset`                 | Pod anti-affinity preset. Ignored if `consentValidator.affinity` is set. Allowed values: `soft` or `hard`                                                     | `""`                                 |
| `consentValidator.nodeAffinityPreset.type`               | Node affinity preset type. Ignored if `consentValidator.affinity` is set. Allowed values: `soft` or `hard`                                                    | `""`                                 |
| `consentValidator.nodeAffinityPreset.key`                | Node label key to match. Ignored if `consentValidator.affinity` is set                                                                                        | `""`                                 |
| `consentValidator.nodeAffinityPreset.values`             | Node label values to match. Ignored if `consentValidator.affinity` is set                                                                                     | `[]`                                 |
| `consentValidator.affinity`                              | Affinity for consentValidator pods assignment                                                                                                                 | `{}`                                 |
| `consentValidator.nodeSelector`                          | Node labels for consentValidator pods assignment                                                                                                              | `nil`                                |
| `consentValidator.tolerations`                           | Tolerations for consentValidator pods assignment                                                                                                              | `[]`                                 |
| `consentValidator.updateStrategy.type`                   | consentValidator statefulset strategy type                                                                                                                    | `RollingUpdate`                      |
| `consentValidator.priorityClassName`                     | consentValidator pods' priorityClassName                                                                                                                      | `""`                                 |
| `consentValidator.schedulerName`                         | Name of the k8s scheduler (other than default) for consentValidator pods                                                                                      | `""`                                 |
| `consentValidator.lifecycleHooks`                        | for the consentValidator container(s) to automate configuration before or after startup                                                                       | `{}`                                 |
| `consentValidator.extraEnvVars`                          | Array with extra environment variables to add to consentValidator nodes                                                                                       | `nil`                                |
| `consentValidator.extraEnvVarsCM`                        | Name of existing ConfigMap containing extra env vars for consentValidator nodes                                                                               | `""`                                 |
| `consentValidator.extraEnvVarsSecret`                    | Name of existing Secret containing extra env vars for consentValidator nodes                                                                                  | `nil`                                |
| `consentValidator.extraVolumes`                          | Optionally specify extra list of additional volumes for the consentValidator pod(s)                                                                           | `nil`                                |
| `consentValidator.extraVolumeMounts`                     | Optionally specify extra list of additional volumeMounts for the consentValidator container(s)                                                                | `nil`                                |
| `consentValidator.sidecars`                              | Add additional sidecar containers to the consentValidator pod(s)                                                                                              | `{}`                                 |
| `consentValidator.initContainers`                        | Add additional init containers to the consentValidator pod(s)                                                                                                 | `{}`                                 |
| `consentValidator.autoscaling.enabled`                   | Enable Horizontal POD autoscaling for Apache                                                                                                        | `false`                              |
| `consentValidator.autoscaling.minReplicas`               | Minimum number of Apache replicas                                                                                                                   | `1`                                  |
| `consentValidator.autoscaling.maxReplicas`               | Maximum number of Apache replicas                                                                                                                   | `5`                                  |
| `consentValidator.autoscaling.targetCPU`                 | Target CPU utilization percentage                                                                                                                   | `80`                                 |
| `consentValidator.autoscaling.targetMemory`              | Target Memory utilization percentage                                                                                                                | `nil`                                |



### Traffic Exposure Parameters

| Name                               | Description                                                                                                                      | Value                    |
| ---------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `service.type`                     | consentValidator service type                                                                                                              | `ClusterIP`              |
| `service.ports`                    | consentValidator service port                                                                                                              | `nil`                    |
| `service.clusterIP`                | Server service Cluster IP                                                                                                     | `None`                   |
| `service.loadBalancerIP`           | consentValidator service Load Balancer IP                                                                                                  | `nil`                    |
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
helm install consent-validator consent-validator \
  --set=slack.channel="#bots",slack.token="XXXX-XXXX-XXXX"
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
helm install consent-validator -f values.yaml consent-validator/
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


