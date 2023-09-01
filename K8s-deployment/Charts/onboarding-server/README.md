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

### apiServer Parameters

| Name                                             | Description                                                                                        | Value                                                                                                                                                                                                                |
| ------------------------------------------------ | -------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `apiServer.replicaCount`                          | Number of apiServer replicas to deploy                                                              | `1`                                                                                                                                                                                                                  |
| `apiServer.livenessProbe.enabled`                 | Enable livenessProbe on apiServer containers                                                        | `true`                                                                                                                                                                                                               |
| `apiServer.livenessProbe.initialDelaySeconds`     | Initial delay seconds for livenessProbe                                                            | `60`                                                                                                                                                                                                                 |
| `apiServer.livenessProbe.periodSeconds`           | Period seconds for livenessProbe                                                                   | `60`                                                                                                                                                                                                                 |
| `apiServer.livenessProbe.timeoutSeconds`          | Timeout seconds for livenessProbe                                                                  | `10`                                                                                                                                                                                                                 |
| `apiServer.livenessProbe.failureThreshold`        | Failure threshold for livenessProbe                                                                | `10`                                                                                                                                                                                                                 |
| `apiServer.livenessProbe.successThreshold`        | Success threshold for livenessProbe                                                                | `10`                                                                                                                                                                                                                 |
| `apiServer.livenessProbe.path`                    | Path for httpGet                                                                                   | `/metrics`                                                                                                                                                                                                           |
| `apiServer.readinessProbe.enabled`                | Enable readinessProbe on apiServer containers                                                       | `false`                                                                                                                                                                                                              |
| `apiServer.readinessProbe.initialDelaySeconds`    | Initial delay seconds for readinessProbe                                                           | `10`                                                                                                                                                                                                                 |
| `apiServer.readinessProbe.periodSeconds`          | Period seconds for readinessProbe                                                                  | `10`                                                                                                                                                                                                                 |
| `apiServer.readinessProbe.timeoutSeconds`         | Timeout seconds for readinessProbe                                                                 | `10`                                                                                                                                                                                                                 |
| `apiServer.readinessProbe.failureThreshold`       | Failure threshold for readinessProbe                                                               | `10`                                                                                                                                                                                                                 |
| `apiServer.readinessProbe.successThreshold`       | Success threshold for readinessProbe                                                               | `10`                                                                                                                                                                                                                 |
| `apiServer.startupProbe.enabled`                  | Enable startupProbe on apiServer containers                                                         | `false`                                                                                                                                                                                                              |
| `apiServer.startupProbe.initialDelaySeconds`      | Initial delay seconds for startupProbe                                                             | `10`                                                                                                                                                                                                                 |
| `apiServer.startupProbe.periodSeconds`            | Period seconds for startupProbe                                                                    | `10`                                                                                                                                                                                                                 |
| `apiServer.startupProbe.timeoutSeconds`           | Timeout seconds for startupProbe                                                                   | `10`                                                                                                                                                                                                                 |
| `apiServer.startupProbe.failureThreshold`         | Failure threshold for startupProbe                                                                 | `10`                                                                                                                                                                                                                 |
| `apiServer.startupProbe.successThreshold`         | Success threshold for startupProbe                                                                 | `10`                                                                                                                                                                                                                 |
| `apiServer.customLivenessProbe`                   | Custom livenessProbe that overrides the default one                                                | `{}`                                                                                                                                                                                                                 |
| `apiServer.customReadinessProbe`                  | Custom readinessProbe that overrides the default one                                               | `{}`                                                                                                                                                                                                                 |
| `apiServer.customStartupProbe`                    | Custom startupProbe that overrides the default one                                                 | `{}`                                                                                                                                                                                                                 |
| `apiServer.resources.limits`                      | The resources limits for the apiServer containers                                                   | `nil`                                                                                                                                                                                                                |
| `apiServer.resources.requests`                    | The requested resources for the apiServer containers                                                | `nil`                                                                                                                                                                                                                |
| `apiServer.podSecurityContext.enabled`            | Enabled apiServer pods' Security Context                                                            | `false`                                                                                                                                                                                                              |
| `apiServer.podSecurityContext.fsGroup`            | Set apiServer pod's Security Context fsGroup                                                        | `1001`                                                                                                                                                                                                               |
| `apiServer.containerSecurityContext.enabled`      | Enabled apiServer containers' Security Context                                                      | `false`                                                                                                                                                                                                              |
| `apiServer.containerSecurityContext.runAsUser`    | Set apiServer containers' Security Context runAsUser                                                | `1001`                                                                                                                                                                                                               |
| `apiServer.containerSecurityContext.runAsNonRoot` | Set apiServer containers' Security Context runAsNonRoot                                             | `true`                                                                                                                                                                                                               |
| `apiServer.existingConfigmap`                     | The name of an existing ConfigMap with your custom configuration for apiServer                      | `nil`                                                                                                                                                                                                                |
| `apiServer.command`                               | Override default container command (useful when using custom images)                               | `["/bin/bash"]`                                                                                                                                                                                                      |
| `apiServer.args`                                  | Override default container args (useful when using custom images)                                  | `["-c","exec java -Xmx1024m -Dvertx.logger-delegate-factory-class-name=io.vertx.core.logging.Log4j2LogDelegateFactory  -jar ./fatjar.jar  --host $$MY_POD_IP -c secrets/one-verticle-configs/config-apiServer.json"]` |
| `apiServer.hostAliases`                           | apiServer pods host aliases                                                                         | `[]`                                                                                                                                                                                                                 |
| `apiServer.podLabels`                             | Extra labels for apiServer pods                                                                     | `{}`                                                                                                                                                                                                                 |
| `apiServer.podAffinityPreset`                     | Pod affinity preset. Ignored if `apiServer.affinity` is set. Allowed values: `soft` or `hard`       | `""`                                                                                                                                                                                                                 |
| `apiServer.podAntiAffinityPreset`                 | Pod anti-affinity preset. Ignored if `apiServer.affinity` is set. Allowed values: `soft` or `hard`  | `""`                                                                                                                                                                                                                 |
| `apiServer.nodeAffinityPreset.type`               | Node affinity preset type. Ignored if `apiServer.affinity` is set. Allowed values: `soft` or `hard` | `""`                                                                                                                                                                                                                 |
| `apiServer.nodeAffinityPreset.key`                | Node label key to match. Ignored if `apiServer.affinity` is set                                     | `""`                                                                                                                                                                                                                 |
| `apiServer.nodeAffinityPreset.values`             | Node label values to match. Ignored if `apiServer.affinity` is set                                  | `[]`                                                                                                                                                                                                                 |
| `apiServer.affinity`                              | Affinity for apiServer pods assignment                                                              | `{}`                                                                                                                                                                                                                 |
| `apiServer.nodeSelector`                          | Node labels for apiServer pods assignment                                                           | `nil`                                                                                                                                                                                                                |
| `apiServer.tolerations`                           | Tolerations for apiServer pods assignment                                                           | `[]`                                                                                                                                                                                                                 |
| `apiServer.updateStrategy.type`                   | apiServer statefulset strategy type                                                                 | `RollingUpdate`                                                                                                                                                                                                      |
| `apiServer.priorityClassName`                     | apiServer pods' priorityClassName                                                                   | `""`                                                                                                                                                                                                                 |
| `apiServer.schedulerName`                         | Name of the k8s scheduler (other than default) for apiServer pods                                   | `""`                                                                                                                                                                                                                 |
| `apiServer.lifecycleHooks`                        | for the apiServer container(s) to automate configuration before or after startup                    | `{}`                                                                                                                                                                                                                 |
| `apiServer.extraEnvVars`                          | Array with extra environment variables to add to apiServer nodes                                    | `[]`                                                                                                                                                                                                                 |
| `apiServer.extraEnvVarsCM`                        | Name of existing ConfigMap containing extra env vars for apiServer nodes                            | `cat-env`                                                                                                                                                                                                            |
| `apiServer.extraEnvVarsSecret`                    | Name of existing Secret containing extra env vars for apiServer nodes                               | `nil`                                                                                                                                                                                                                |
| `apiServer.extraVolumes`                          | Optionally specify extra list of additional volumes for the apiServer pod(s)                        | `nil`                                                                                                                                                                                                                |
| `apiServer.extraVolumeMounts`                     | Optionally specify extra list of additional volumeMounts for the apiServer container(s)             | `nil`                                                                                                                                                                                                                |
| `apiServer.sidecars`                              | Add additional sidecar containers to the apiServer pod(s)                                           | `{}`                                                                                                                                                                                                                 |
| `apiServer.initContainers`                        | Add additional init containers to the apiServer pod(s)                                              | `{}`                                                                                                                                                                                                                 |
| `apiServer.autoscaling.enabled`                   | Enable Horizontal POD autoscaling for Apache                                                       | `false`                                                                                                                                                                                                              |
| `apiServer.autoscaling.minReplicas`               | Minimum number of Apache replicas                                                                  | `1`                                                                                                                                                                                                                  |
| `apiServer.autoscaling.maxReplicas`               | Maximum number of Apache replicas                                                                  | `5`                                                                                                                                                                                                                  |
| `apiServer.autoscaling.targetCPU`                 | Target CPU utilization percentage                                                                  | `80`                                                                                                                                                                                                                 |
| `apiServer.autoscaling.targetMemory`              | Target Memory utilization percentage                                                               | `nil`          



### catalogue Parameters

| Name                                             | Description                                                                                        | Value                                                                                                                                                                                                                |
| ------------------------------------------------ | -------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `catalogue.replicaCount`                          | Number of catalogue replicas to deploy                                                              | `1`                                                                                                                                                                                                                  |
| `catalogue.livenessProbe.enabled`                 | Enable livenessProbe on catalogue containers                                                        | `true`                                                                                                                                                                                                               |
| `catalogue.livenessProbe.initialDelaySeconds`     | Initial delay seconds for livenessProbe                                                            | `60`                                                                                                                                                                                                                 |
| `catalogue.livenessProbe.periodSeconds`           | Period seconds for livenessProbe                                                                   | `60`                                                                                                                                                                                                                 |
| `catalogue.livenessProbe.timeoutSeconds`          | Timeout seconds for livenessProbe                                                                  | `10`                                                                                                                                                                                                                 |
| `catalogue.livenessProbe.failureThreshold`        | Failure threshold for livenessProbe                                                                | `10`                                                                                                                                                                                                                 |
| `catalogue.livenessProbe.successThreshold`        | Success threshold for livenessProbe                                                                | `10`                                                                                                                                                                                                                 |
| `catalogue.livenessProbe.path`                    | Path for httpGet                                                                                   | `/metrics`                                                                                                                                                                                                           |
| `catalogue.readinessProbe.enabled`                | Enable readinessProbe on catalogue containers                                                       | `false`                                                                                                                                                                                                              |
| `catalogue.readinessProbe.initialDelaySeconds`    | Initial delay seconds for readinessProbe                                                           | `10`                                                                                                                                                                                                                 |
| `catalogue.readinessProbe.periodSeconds`          | Period seconds for readinessProbe                                                                  | `10`                                                                                                                                                                                                                 |
| `catalogue.readinessProbe.timeoutSeconds`         | Timeout seconds for readinessProbe                                                                 | `10`                                                                                                                                                                                                                 |
| `catalogue.readinessProbe.failureThreshold`       | Failure threshold for readinessProbe                                                               | `10`                                                                                                                                                                                                                 |
| `catalogue.readinessProbe.successThreshold`       | Success threshold for readinessProbe                                                               | `10`                                                                                                                                                                                                                 |
| `catalogue.startupProbe.enabled`                  | Enable startupProbe on catalogue containers                                                         | `false`                                                                                                                                                                                                              |
| `catalogue.startupProbe.initialDelaySeconds`      | Initial delay seconds for startupProbe                                                             | `10`                                                                                                                                                                                                                 |
| `catalogue.startupProbe.periodSeconds`            | Period seconds for startupProbe                                                                    | `10`                                                                                                                                                                                                                 |
| `catalogue.startupProbe.timeoutSeconds`           | Timeout seconds for startupProbe                                                                   | `10`                                                                                                                                                                                                                 |
| `catalogue.startupProbe.failureThreshold`         | Failure threshold for startupProbe                                                                 | `10`                                                                                                                                                                                                                 |
| `catalogue.startupProbe.successThreshold`         | Success threshold for startupProbe                                                                 | `10`                                                                                                                                                                                                                 |
| `catalogue.customLivenessProbe`                   | Custom livenessProbe that overrides the default one                                                | `{}`                                                                                                                                                                                                                 |
| `catalogue.customReadinessProbe`                  | Custom readinessProbe that overrides the default one                                               | `{}`                                                                                                                                                                                                                 |
| `catalogue.customStartupProbe`                    | Custom startupProbe that overrides the default one                                                 | `{}`                                                                                                                                                                                                                 |
| `catalogue.resources.limits`                      | The resources limits for the catalogue containers                                                   | `nil`                                                                                                                                                                                                                |
| `catalogue.resources.requests`                    | The requested resources for the catalogue containers                                                | `nil`                                                                                                                                                                                                                |
| `catalogue.podSecurityContext.enabled`            | Enabled catalogue pods' Security Context                                                            | `false`                                                                                                                                                                                                              |
| `catalogue.podSecurityContext.fsGroup`            | Set catalogue pod's Security Context fsGroup                                                        | `1001`                                                                                                                                                                                                               |
| `catalogue.containerSecurityContext.enabled`      | Enabled catalogue containers' Security Context                                                      | `false`                                                                                                                                                                                                              |
| `catalogue.containerSecurityContext.runAsUser`    | Set catalogue containers' Security Context runAsUser                                                | `1001`                                                                                                                                                                                                               |
| `catalogue.containerSecurityContext.runAsNonRoot` | Set catalogue containers' Security Context runAsNonRoot                                             | `true`                                                                                                                                                                                                               |
| `catalogue.existingConfigmap`                     | The name of an existing ConfigMap with your custom configuration for catalogue                      | `nil`                                                                                                                                                                                                                |
| `catalogue.command`                               | Override default container command (useful when using custom images)                               | `["/bin/bash"]`                                                                                                                                                                                                      |
| `catalogue.args`                                  | Override default container args (useful when using custom images)                                  | `["-c","exec java -Xmx1024m -Dvertx.logger-delegate-factory-class-name=io.vertx.core.logging.Log4j2LogDelegateFactory  -jar ./fatjar.jar  --host $$MY_POD_IP -c secrets/one-verticle-configs/config-catalogue.json"]` |
| `catalogue.hostAliases`                           | catalogue pods host aliases                                                                         | `[]`                                                                                                                                                                                                                 |
| `catalogue.podLabels`                             | Extra labels for catalogue pods                                                                     | `{}`                                                                                                                                                                                                                 |
| `catalogue.podAffinityPreset`                     | Pod affinity preset. Ignored if `catalogue.affinity` is set. Allowed values: `soft` or `hard`       | `""`                                                                                                                                                                                                                 |
| `catalogue.podAntiAffinityPreset`                 | Pod anti-affinity preset. Ignored if `catalogue.affinity` is set. Allowed values: `soft` or `hard`  | `""`                                                                                                                                                                                                                 |
| `catalogue.nodeAffinityPreset.type`               | Node affinity preset type. Ignored if `catalogue.affinity` is set. Allowed values: `soft` or `hard` | `""`                                                                                                                                                                                                                 |
| `catalogue.nodeAffinityPreset.key`                | Node label key to match. Ignored if `catalogue.affinity` is set                                     | `""`                                                                                                                                                                                                                 |
| `catalogue.nodeAffinityPreset.values`             | Node label values to match. Ignored if `catalogue.affinity` is set                                  | `[]`                                                                                                                                                                                                                 |
| `catalogue.affinity`                              | Affinity for catalogue pods assignment                                                              | `{}`                                                                                                                                                                                                                 |
| `catalogue.nodeSelector`                          | Node labels for catalogue pods assignment                                                           | `nil`                                                                                                                                                                                                                |
| `catalogue.tolerations`                           | Tolerations for catalogue pods assignment                                                           | `[]`                                                                                                                                                                                                                 |
| `catalogue.updateStrategy.type`                   | catalogue statefulset strategy type                                                                 | `RollingUpdate`                                                                                                                                                                                                      |
| `catalogue.priorityClassName`                     | catalogue pods' priorityClassName                                                                   | `""`                                                                                                                                                                                                                 |
| `catalogue.schedulerName`                         | Name of the k8s scheduler (other than default) for catalogue pods                                   | `""`                                                                                                                                                                                                                 |
| `catalogue.lifecycleHooks`                        | for the catalogue container(s) to automate configuration before or after startup                    | `{}`                                                                                                                                                                                                                 |
| `catalogue.extraEnvVars`                          | Array with extra environment variables to add to catalogue nodes                                    | `[]`                                                                                                                                                                                                                 |
| `catalogue.extraEnvVarsCM`                        | Name of existing ConfigMap containing extra env vars for catalogue nodes                            | `cat-env`                                                                                                                                                                                                            |
| `catalogue.extraEnvVarsSecret`                    | Name of existing Secret containing extra env vars for catalogue nodes                               | `nil`                                                                                                                                                                                                                |
| `catalogue.extraVolumes`                          | Optionally specify extra list of additional volumes for the catalogue pod(s)                        | `nil`                                                                                                                                                                                                                |
| `catalogue.extraVolumeMounts`                     | Optionally specify extra list of additional volumeMounts for the catalogue container(s)             | `nil`                                                                                                                                                                                                                |
| `catalogue.sidecars`                              | Add additional sidecar containers to the catalogue pod(s)                                           | `{}`                                                                                                                                                                                                                 |
| `catalogue.initContainers`                        | Add additional init containers to the catalogue pod(s)                                              | `{}`                                                                                                                                                                                                                 |
| `catalogue.autoscaling.enabled`                   | Enable Horizontal POD autoscaling for Apache                                                       | `false`                                                                                                                                                                                                              |
| `catalogue.autoscaling.minReplicas`               | Minimum number of Apache replicas                                                                  | `1`                                                                                                                                                                                                                  |
| `catalogue.autoscaling.maxReplicas`               | Maximum number of Apache replicas                                                                  | `5`                                                                                                                                                                                                                  |
| `catalogue.autoscaling.targetCPU`                 | Target CPU utilization percentage                                                                  | `80`                                                                                                                                                                                                                 |
| `catalogue.autoscaling.targetMemory`              | Target Memory utilization percentage                                                               | `nil`                                                                                                                                 



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

### token Parameters

| Name                                             | Description                                                                                        | Value                                                                                                                                                                                                                |
| ------------------------------------------------ | -------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `token.replicaCount`                          | Number of token replicas to deploy                                                              | `1`                                                                                                                                                                                                                  |
| `token.livenessProbe.enabled`                 | Enable livenessProbe on token containers                                                        | `true`                                                                                                                                                                                                               |
| `token.livenessProbe.initialDelaySeconds`     | Initial delay seconds for livenessProbe                                                            | `60`                                                                                                                                                                                                                 |
| `token.livenessProbe.periodSeconds`           | Period seconds for livenessProbe                                                                   | `60`                                                                                                                                                                                                                 |
| `token.livenessProbe.timeoutSeconds`          | Timeout seconds for livenessProbe                                                                  | `10`                                                                                                                                                                                                                 |
| `token.livenessProbe.failureThreshold`        | Failure threshold for livenessProbe                                                                | `10`                                                                                                                                                                                                                 |
| `token.livenessProbe.successThreshold`        | Success threshold for livenessProbe                                                                | `10`                                                                                                                                                                                                                 |
| `token.livenessProbe.path`                    | Path for httpGet                                                                                   | `/metrics`                                                                                                                                                                                                           |
| `token.readinessProbe.enabled`                | Enable readinessProbe on token containers                                                       | `false`                                                                                                                                                                                                              |
| `token.readinessProbe.initialDelaySeconds`    | Initial delay seconds for readinessProbe                                                           | `10`                                                                                                                                                                                                                 |
| `token.readinessProbe.periodSeconds`          | Period seconds for readinessProbe                                                                  | `10`                                                                                                                                                                                                                 |
| `token.readinessProbe.timeoutSeconds`         | Timeout seconds for readinessProbe                                                                 | `10`                                                                                                                                                                                                                 |
| `token.readinessProbe.failureThreshold`       | Failure threshold for readinessProbe                                                               | `10`                                                                                                                                                                                                                 |
| `token.readinessProbe.successThreshold`       | Success threshold for readinessProbe                                                               | `10`                                                                                                                                                                                                                 |
| `token.startupProbe.enabled`                  | Enable startupProbe on token containers                                                         | `false`                                                                                                                                                                                                              |
| `token.startupProbe.initialDelaySeconds`      | Initial delay seconds for startupProbe                                                             | `10`                                                                                                                                                                                                                 |
| `token.startupProbe.periodSeconds`            | Period seconds for startupProbe                                                                    | `10`                                                                                                                                                                                                                 |
| `token.startupProbe.timeoutSeconds`           | Timeout seconds for startupProbe                                                                   | `10`                                                                                                                                                                                                                 |
| `token.startupProbe.failureThreshold`         | Failure threshold for startupProbe                                                                 | `10`                                                                                                                                                                                                                 |
| `token.startupProbe.successThreshold`         | Success threshold for startupProbe                                                                 | `10`                                                                                                                                                                                                                 |
| `token.customLivenessProbe`                   | Custom livenessProbe that overrides the default one                                                | `{}`                                                                                                                                                                                                                 |
| `token.customReadinessProbe`                  | Custom readinessProbe that overrides the default one                                               | `{}`                                                                                                                                                                                                                 |
| `token.customStartupProbe`                    | Custom startupProbe that overrides the default one                                                 | `{}`                                                                                                                                                                                                                 |
| `token.resources.limits`                      | The resources limits for the token containers                                                   | `nil`                                                                                                                                                                                                                |
| `token.resources.requests`                    | The requested resources for the token containers                                                | `nil`                                                                                                                                                                                                                |
| `token.podSecurityContext.enabled`            | Enabled token pods' Security Context                                                            | `false`                                                                                                                                                                                                              |
| `token.podSecurityContext.fsGroup`            | Set token pod's Security Context fsGroup                                                        | `1001`                                                                                                                                                                                                               |
| `token.containerSecurityContext.enabled`      | Enabled token containers' Security Context                                                      | `false`                                                                                                                                                                                                              |
| `token.containerSecurityContext.runAsUser`    | Set token containers' Security Context runAsUser                                                | `1001`                                                                                                                                                                                                               |
| `token.containerSecurityContext.runAsNonRoot` | Set token containers' Security Context runAsNonRoot                                             | `true`                                                                                                                                                                                                               |
| `token.existingConfigmap`                     | The name of an existing ConfigMap with your custom configuration for token                      | `nil`                                                                                                                                                                                                                |
| `token.command`                               | Override default container command (useful when using custom images)                               | `["/bin/bash"]`                                                                                                                                                                                                      |
| `token.args`                                  | Override default container args (useful when using custom images)                                  | `["-c","exec java -Xmx1024m -Dvertx.logger-delegate-factory-class-name=io.vertx.core.logging.Log4j2LogDelegateFactory  -jar ./fatjar.jar  --host $$MY_POD_IP -c secrets/one-verticle-configs/config-token.json"]` |
| `token.hostAliases`                           | token pods host aliases                                                                         | `[]`                                                                                                                                                                                                                 |
| `token.podLabels`                             | Extra labels for token pods                                                                     | `{}`                                                                                                                                                                                                                 |
| `token.podAffinityPreset`                     | Pod affinity preset. Ignored if `token.affinity` is set. Allowed values: `soft` or `hard`       | `""`                                                                                                                                                                                                                 |
| `token.podAntiAffinityPreset`                 | Pod anti-affinity preset. Ignored if `token.affinity` is set. Allowed values: `soft` or `hard`  | `""`                                                                                                                                                                                                                 |
| `token.nodeAffinityPreset.type`               | Node affinity preset type. Ignored if `token.affinity` is set. Allowed values: `soft` or `hard` | `""`                                                                                                                                                                                                                 |
| `token.nodeAffinityPreset.key`                | Node label key to match. Ignored if `token.affinity` is set                                     | `""`                                                                                                                                                                                                                 |
| `token.nodeAffinityPreset.values`             | Node label values to match. Ignored if `token.affinity` is set                                  | `[]`                                                                                                                                                                                                                 |
| `token.affinity`                              | Affinity for token pods assignment                                                              | `{}`                                                                                                                                                                                                                 |
| `token.nodeSelector`                          | Node labels for token pods assignment                                                           | `nil`                                                                                                                                                                                                                |
| `token.tolerations`                           | Tolerations for token pods assignment                                                           | `[]`                                                                                                                                                                                                                 |
| `token.updateStrategy.type`                   | token statefulset strategy type                                                                 | `RollingUpdate`                                                                                                                                                                                                      |
| `token.priorityClassName`                     | token pods' priorityClassName                                                                   | `""`                                                                                                                                                                                                                 |
| `token.schedulerName`                         | Name of the k8s scheduler (other than default) for token pods                                   | `""`                                                                                                                                                                                                                 |
| `token.lifecycleHooks`                        | for the token container(s) to automate configuration before or after startup                    | `{}`                                                                                                                                                                                                                 |
| `token.extraEnvVars`                          | Array with extra environment variables to add to token nodes                                    | `[]`                                                                                                                                                                                                                 |
| `token.extraEnvVarsCM`                        | Name of existing ConfigMap containing extra env vars for token nodes                            | `cat-env`                                                                                                                                                                                                            |
| `token.extraEnvVarsSecret`                    | Name of existing Secret containing extra env vars for token nodes                               | `nil`                                                                                                                                                                                                                |
| `token.extraVolumes`                          | Optionally specify extra list of additional volumes for the token pod(s)                        | `nil`                                                                                                                                                                                                                |
| `token.extraVolumeMounts`                     | Optionally specify extra list of additional volumeMounts for the token container(s)             | `nil`                                                                                                                                                                                                                |
| `token.sidecars`                              | Add additional sidecar containers to the token pod(s)                                           | `{}`                                                                                                                                                                                                                 |
| `token.initContainers`                        | Add additional init containers to the token pod(s)                                              | `{}`                                                                                                                                                                                                                 |
| `token.autoscaling.enabled`                   | Enable Horizontal POD autoscaling for Apache                                                       | `false`                                                                                                                                                                                                              |
| `token.autoscaling.minReplicas`               | Minimum number of Apache replicas                                                                  | `1`                                                                                                                                                                                                                  |
| `token.autoscaling.maxReplicas`               | Maximum number of Apache replicas                                                                  | `5`                                                                                                                                                                                                                  |
| `token.autoscaling.targetCPU`                 | Target CPU utilization percentage                                                                  | `80`                                                                                                                                                                                                                 |
| `token.autoscaling.targetMemory`              | Target Memory utilization percentage                                                               | `nil`          


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


