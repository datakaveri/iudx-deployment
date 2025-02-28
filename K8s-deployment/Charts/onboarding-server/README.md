## Introduction

Helm Chart for IUDX onboarding-server Server Deployment

## Create secret files

Make a copy of sample secrets directory and add appropriate values to all files.

```console
 cp -r example-secrets/* .
```

```
# secrets directory after generation of secret files
secrets/
├── .onboarding.env
└── config.json
```

## Define Appropriate values of resources

Define Appropriate values of resources -
- CPU of all onboarding-server verticles
- RAM of all onboarding-server verticles

in `resource-values.yaml` as shown in sample resource-values onboarding for [`aws`](./example-aws-resource-values.yaml) and [`azure`](./example-azure-resource-values.yaml)

## Installing the Chart

To install the `onboarding-server`chart:

```console
 ./install.sh
```

The command deploys  resource-server on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

Following script will create :
1. create a namespace `onboarding`
2. create required configmaps
3. create corresponding K8s secrets from the secret files
4. deploy all onboarding-server verticles 


## Uninstalling the Chart

To uninstall/delete the `onboarding-server` deployment:

```console
 helm delete onboarding-server -n onboarding
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
| `nameSpace`              | Namespace to deploy the controller                                                      | `onboarding`           |
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
| `image.repository`          | image repository                           | `datakaveri/onboarding-server-depl` |
| `image.tag`                 | image tag (immutable tags are recommended) | `3.0-2a93bdf`        |
| `image.pullPolicy`          | image pull policy                          | `IfNotPresent`       |
| `image.pullSecrets`         | image pull secrets                         | `{}`                 |
| `image.debug`               | Enable image debug mode                    | `false`              |
| `containerPorts.http`       | HTTP container port                        | `8080`                 |
| `containerPorts.https`      | HTTPS container port                       | `8443`                |
| `containerPorts.hazelcast`  | Hazelcast container port                   | `5701`               |
| `containerPorts.prometheus` | Prometheus container port                  | `9000`               |
| `podAnnotations`            | Annotations for pods                       | `nil`                |

### onboardingServer Parameters

| Name                                             | Description                                                                                        | Value                                                                                                                                                                                                                |
| ------------------------------------------------ | -------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `onboardingServer.replicaCount`                          | Number of onboardingServer replicas to deploy                                                              | `1`                                                                                                                                                                                                                  |
| `onboardingServer.livenessProbe.enabled`                 | Enable livenessProbe on onboardingServer containers                                                        | `true`                                                                                                                                                                                                               |
| `onboardingServer.livenessProbe.initialDelaySeconds`     | Initial delay seconds for livenessProbe                                                            | `60`                                                                                                                                                                                                                 |
| `onboardingServer.livenessProbe.periodSeconds`           | Period seconds for livenessProbe                                                                   | `60`                                                                                                                                                                                                                 |
| `onboardingServer.livenessProbe.timeoutSeconds`          | Timeout seconds for livenessProbe                                                                  | `10`                                                                                                                                                                                                                 |
| `onboardingServer.livenessProbe.failureThreshold`        | Failure threshold for livenessProbe                                                                | `10`                                                                                                                                                                                                                 |
| `onboardingServer.livenessProbe.successThreshold`        | Success threshold for livenessProbe                                                                | `10`                                                                                                                                                                                                                 |
| `onboardingServer.livenessProbe.path`                    | Path for httpGet                                                                                   | `/metrics`                                                                                                                                                                                                           |
| `onboardingServer.readinessProbe.enabled`                | Enable readinessProbe on onboardingServer containers                                                       | `false`                                                                                                                                                                                                              |
| `onboardingServer.readinessProbe.initialDelaySeconds`    | Initial delay seconds for readinessProbe                                                           | `10`                                                                                                                                                                                                                 |
| `onboardingServer.readinessProbe.periodSeconds`          | Period seconds for readinessProbe                                                                  | `10`                                                                                                                                                                                                                 |
| `onboardingServer.readinessProbe.timeoutSeconds`         | Timeout seconds for readinessProbe                                                                 | `10`                                                                                                                                                                                                                 |
| `onboardingServer.readinessProbe.failureThreshold`       | Failure threshold for readinessProbe                                                               | `10`                                                                                                                                                                                                                 |
| `onboardingServer.readinessProbe.successThreshold`       | Success threshold for readinessProbe                                                               | `10`                                                                                                                                                                                                                 |
| `onboardingServer.startupProbe.enabled`                  | Enable startupProbe on onboardingServer containers                                                         | `false`                                                                                                                                                                                                              |
| `onboardingServer.startupProbe.initialDelaySeconds`      | Initial delay seconds for startupProbe                                                             | `10`                                                                                                                                                                                                                 |
| `onboardingServer.startupProbe.periodSeconds`            | Period seconds for startupProbe                                                                    | `10`                                                                                                                                                                                                                 |
| `onboardingServer.startupProbe.timeoutSeconds`           | Timeout seconds for startupProbe                                                                   | `10`                                                                                                                                                                                                                 |
| `onboardingServer.startupProbe.failureThreshold`         | Failure threshold for startupProbe                                                                 | `10`                                                                                                                                                                                                                 |
| `onboardingServer.startupProbe.successThreshold`         | Success threshold for startupProbe                                                                 | `10`                                                                                                                                                                                                                 |
| `onboardingServer.customLivenessProbe`                   | Custom livenessProbe that overrides the default one                                                | `{}`                                                                                                                                                                                                                 |
| `onboardingServer.customReadinessProbe`                  | Custom readinessProbe that overrides the default one                                               | `{}`                                                                                                                                                                                                                 |
| `onboardingServer.customStartupProbe`                    | Custom startupProbe that overrides the default one                                                 | `{}`                                                                                                                                                                                                                 |
| `onboardingServer.resources.limits`                      | The resources limits for the onboardingServer containers                                                   | `nil`                                                                                                                                                                                                                |
| `onboardingServer.resources.requests`                    | The requested resources for the onboardingServer containers                                                | `nil`                                                                                                                                                                                                                |
| `onboardingServer.podSecurityContext.enabled`            | Enabled onboardingServer pods' Security Context                                                            | `false`                                                                                                                                                                                                              |
| `onboardingServer.podSecurityContext.fsGroup`            | Set onboardingServer pod's Security Context fsGroup                                                        | `1001`                                                                                                                                                                                                               |
| `onboardingServer.containerSecurityContext.enabled`      | Enabled onboardingServer containers' Security Context                                                      | `false`                                                                                                                                                                                                              |
| `onboardingServer.containerSecurityContext.runAsUser`    | Set onboardingServer containers' Security Context runAsUser                                                | `1001`                                                                                                                                                                                                               |
| `onboardingServer.containerSecurityContext.runAsNonRoot` | Set onboardingServer containers' Security Context runAsNonRoot                                             | `true`                                                                                                                                                                                                               |
| `onboardingServer.existingConfigmap`                     | The name of an existing ConfigMap with your custom configuration for onboardingServer                      | `nil`                                                                                                                                                                                                                |
| `onboardingServer.command`                               | Override default container command (useful when using custom images)                               | `["/bin/bash"]`                                                                                                                                                                                                      |
| `onboardingServer.args`                                  | Override default container args (useful when using custom images)                                  | `["-c","exec java -Xmx1024m -Dvertx.logger-delegate-factory-class-name=io.vertx.core.logging.Log4j2LogDelegateFactory  -jar ./fatjar.jar  --host $$MY_POD_IP -c secrets/one-verticle-configs/config-onboardingServer.json"]` |
| `onboardingServer.hostAliases`                           | onboardingServer pods host aliases                                                                         | `[]`                                                                                                                                                                                                                 |
| `onboardingServer.podLabels`                             | Extra labels for onboardingServer pods                                                                     | `{}`                                                                                                                                                                                                                 |
| `onboardingServer.podAffinityPreset`                     | Pod affinity preset. Ignored if `onboardingServer.affinity` is set. Allowed values: `soft` or `hard`       | `""`                                                                                                                                                                                                                 |
| `onboardingServer.podAntiAffinityPreset`                 | Pod anti-affinity preset. Ignored if `onboardingServer.affinity` is set. Allowed values: `soft` or `hard`  | `""`                                                                                                                                                                                                                 |
| `onboardingServer.nodeAffinityPreset.type`               | Node affinity preset type. Ignored if `onboardingServer.affinity` is set. Allowed values: `soft` or `hard` | `""`                                                                                                                                                                                                                 |
| `onboardingServer.nodeAffinityPreset.key`                | Node label key to match. Ignored if `onboardingServer.affinity` is set                                     | `""`                                                                                                                                                                                                                 |
| `onboardingServer.nodeAffinityPreset.values`             | Node label values to match. Ignored if `onboardingServer.affinity` is set                                  | `[]`                                                                                                                                                                                                                 |
| `onboardingServer.affinity`                              | Affinity for onboardingServer pods assignment                                                              | `{}`                                                                                                                                                                                                                 |
| `onboardingServer.nodeSelector`                          | Node labels for onboardingServer pods assignment                                                           | `nil`                                                                                                                                                                                                                |
| `onboardingServer.tolerations`                           | Tolerations for onboardingServer pods assignment                                                           | `[]`                                                                                                                                                                                                                 |
| `onboardingServer.updateStrategy.type`                   | onboardingServer statefulset strategy type                                                                 | `RollingUpdate`                                                                                                                                                                                                      |
| `onboardingServer.priorityClassName`                     | onboardingServer pods' priorityClassName                                                                   | `""`                                                                                                                                                                                                                 |
| `onboardingServer.schedulerName`                         | Name of the k8s scheduler (other than default) for onboardingServer pods                                   | `""`                                                                                                                                                                                                                 |
| `onboardingServer.lifecycleHooks`                        | for the onboardingServer container(s) to automate configuration before or after startup                    | `{}`                                                                                                                                                                                                                 |
| `onboardingServer.extraEnvVars`                          | Array with extra environment variables to add to onboardingServer nodes                                    | `[]`                                                                                                                                                                                                                 |
| `onboardingServer.extraEnvVarsCM`                        | Name of existing ConfigMap containing extra env vars for onboardingServer nodes                            | `cat-env`                                                                                                                                                                                                            |
| `onboardingServer.extraEnvVarsSecret`                    | Name of existing Secret containing extra env vars for onboardingServer nodes                               | `nil`                                                                                                                                                                                                                |
| `onboardingServer.extraVolumes`                          | Optionally specify extra list of additional volumes for the onboardingServer pod(s)                        | `nil`                                                                                                                                                                                                                |
| `onboardingServer.extraVolumeMounts`                     | Optionally specify extra list of additional volumeMounts for the onboardingServer container(s)             | `nil`                                                                                                                                                                                                                |
| `onboardingServer.sidecars`                              | Add additional sidecar containers to the onboardingServer pod(s)                                           | `{}`                                                                                                                                                                                                                 |
| `onboardingServer.initContainers`                        | Add additional init containers to the onboardingServer pod(s)                                              | `{}`                                                                                                                                                                                                                 |
| `onboardingServer.autoscaling.enabled`                   | Enable Horizontal POD autoscaling for Apache                                                       | `false`                                                                                                                                                                                                              |
| `onboardingServer.autoscaling.minReplicas`               | Minimum number of Apache replicas                                                                  | `1`                                                                                                                                                                                                                  |
| `onboardingServer.autoscaling.maxReplicas`               | Maximum number of Apache replicas                                                                  | `5`                                                                                                                                                                                                                  |
| `onboardingServer.autoscaling.targetCPU`                 | Target CPU utilization percentage                                                                  | `80`                                                                                                                                                                                                                 |
| `onboardingServer.autoscaling.targetMemory`              | Target Memory utilization percentage                                                               | `nil`          


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
 helm install onboarding-server onboarding-server \
  --set=slack.channel="#bots",slack.token="XXXX-XXXX-XXXX"
```

Alternatively, a YAML onboarding that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
 helm install onboarding-server -f values.yaml onboarding-server/
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
