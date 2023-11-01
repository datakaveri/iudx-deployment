[![Kubescape Status](https://img.shields.io/jenkins/build?jobUrl=https%3A%2F%2Fjenkins.iudx.io%2Fjob%2Fkubescape-gis%2F&label=Kubescape)](https://jenkins.iudx.io/job/kubescape-gis/lastBuild/Kubescape_20Scan_20Report_20for_20GIS/)

## Introduction

Helm Chart for IUDX GIS Interface Deployment

## Create secret files

Make a copy of sample secrets directory and add appropriate values to all files.

```console
 cp -r example-secrets/* .
```

```
# secrets directory after generation of secret files
secrets/
├── .gis-api.env
└── config.json
```

## Define Appropriate values of resources

Define Appropriate values of resources -
- CPU of all gis-interface verticles
- RAM of all gis-interface verticles
- ingress.hostname
- cert-manager issuer

in `resource-values.yaml` as shown in sample resource-values file for [`aws`](./example-aws-resource-values.yaml) and [`azure`](./example-azure-resource-values.yaml)

## Installing the Chart

To install the `gis-interface`chart:

```console
 ./install.sh  --set ingress.hostname=<gis-hostname>
```

The command deploys  resource-server on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

Following script will create :
1. create a namespace `gis`
2. create required configmaps
3. create corresponding K8s secrets from the secret files
4. deploy all gis-interface verticles 

### To create ingress redirect to cos url:
```console
kubectl apply -f ../../misc/redirect-gis-ingress.yaml -n gis
```

## Uninstalling the Chart

To uninstall/delete the `gis-interface` deployment:

```console
 helm delete gis-interface -n gis
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

| Name                        | Description                                                   | Value                |
| --------------------------- | ------------------------------------------------------------- | -------------------- |
| `image.registry`            | gis-interface image registry                             | `ghcr.io`            |
| `image.repository`          | gis-interface image repository                           | `datakaveri/gis-depl` |
| `image.tag`                 | gis-interface image tag (immutable tags are recommended) | `3.0-fc10a3a`        |
| `image.pullPolicy`          | gis-interface image pull policy                          | `IfNotPresent`       |
| `image.pullSecrets`         | gis-interface image pull secrets                         | `nil`                |
| `image.debug`               | Enable gis-interface image debug mode                    | `false`              |
| `containerPorts.http`       | HTTP container port                                           | `80`                 |
| `containerPorts.hazelcast`  | Hazelcast container port                                      | `5701`               |
| `containerPorts.prometheus` | Prometheus container port                                     | `9000`               |
| `podAnnotations`            | Annotations for pods                                          | `nil`                |


### ApiServer Parameters

| Name                                              | Description                                                                                         | Value                                                                                                                                                                                                                |
| ------------------------------------------------- | --------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `apiServer.replicaCount`                          | Number of apiServer replicas to deploy                                                              | `1`                                                                                                                                                                                                                  |
| `apiServer.livenessProbe.enabled`                 | Enable livenessProbe on apiServer containers                                                        | `true`                                                                                                                                                                                                               |
| `apiServer.livenessProbe.initialDelaySeconds`     | Initial delay seconds for livenessProbe                                                             | `60`                                                                                                                                                                                                                 |
| `apiServer.livenessProbe.periodSeconds`           | Period seconds for livenessProbe                                                                    | `60`                                                                                                                                                                                                                 |
| `apiServer.livenessProbe.timeoutSeconds`          | Timeout seconds for livenessProbe                                                                   | `10`                                                                                                                                                                                                                 |
| `apiServer.livenessProbe.failureThreshold`        | Failure threshold for livenessProbe                                                                 | `10`                                                                                                                                                                                                                 |
| `apiServer.livenessProbe.successThreshold`        | Success threshold for livenessProbe                                                                 | `10`                                                                                                                                                                                                                 |
| `apiServer.livenessProbe.path`                    | Path for httpGet                                                                                    | `/metrics`                                                                                                                                                                                                           |
| `apiServer.readinessProbe.enabled`                | Enable readinessProbe on apiServer containers                                                       | `false`                                                                                                                                                                                                              |
| `apiServer.readinessProbe.initialDelaySeconds`    | Initial delay seconds for readinessProbe                                                            | `10`                                                                                                                                                                                                                 |
| `apiServer.readinessProbe.periodSeconds`          | Period seconds for readinessProbe                                                                   | `10`                                                                                                                                                                                                                 |
| `apiServer.readinessProbe.timeoutSeconds`         | Timeout seconds for readinessProbe                                                                  | `10`                                                                                                                                                                                                                 |
| `apiServer.readinessProbe.failureThreshold`       | Failure threshold for readinessProbe                                                                | `10`                                                                                                                                                                                                                 |
| `apiServer.readinessProbe.successThreshold`       | Success threshold for readinessProbe                                                                | `10`                                                                                                                                                                                                                 |
| `apiServer.startupProbe.enabled`                  | Enable startupProbe on apiServer containers                                                         | `false`                                                                                                                                                                                                              |
| `apiServer.startupProbe.initialDelaySeconds`      | Initial delay seconds for startupProbe                                                              | `10`                                                                                                                                                                                                                 |
| `apiServer.startupProbe.periodSeconds`            | Period seconds for startupProbe                                                                     | `10`                                                                                                                                                                                                                 |
| `apiServer.startupProbe.timeoutSeconds`           | Timeout seconds for startupProbe                                                                    | `10`                                                                                                                                                                                                                 |
| `apiServer.startupProbe.failureThreshold`         | Failure threshold for startupProbe                                                                  | `10`                                                                                                                                                                                                                 |
| `apiServer.startupProbe.successThreshold`         | Success threshold for startupProbe                                                                  | `10`                                                                                                                                                                                                                 |
| `apiServer.customLivenessProbe`                   | Custom livenessProbe that overrides the default one                                                 | `{}`                                                                                                                                                                                                                 |
| `apiServer.customReadinessProbe`                  | Custom readinessProbe that overrides the default one                                                | `{}`                                                                                                                                                                                                                 |
| `apiServer.customStartupProbe`                    | Custom startupProbe that overrides the default one                                                  | `{}`                                                                                                                                                                                                                 |
| `apiServer.resources.limits`                      | The resources limits for the apiServer containers                                                   | `nil`                                                                                                                                                                                                                |
| `apiServer.resources.requests`                    | The requested resources for the apiServer containers                                                | `nil`                                                                                                                                                                                                                |
| `apiServer.podSecurityContext.enabled`            | Enabled apiServer pods' Security Context                                                            | `false`                                                                                                                                                                                                              |
| `apiServer.podSecurityContext.fsGroup`            | Set apiServer pod's Security Context fsGroup                                                        | `1001`                                                                                                                                                                                                               |
| `apiServer.containerSecurityContext.enabled`      | Enabled apiServer containers' Security Context                                                      | `false`                                                                                                                                                                                                              |
| `apiServer.containerSecurityContext.runAsUser`    | Set apiServer containers' Security Context runAsUser                                                | `1001`                                                                                                                                                                                                               |
| `apiServer.containerSecurityContext.runAsNonRoot` | Set apiServer containers' Security Context runAsNonRoot                                             | `true`                                                                                                                                                                                                               |
| `apiServer.existingConfigmap`                     | The name of an existing ConfigMap with your custom configuration for apiServer                      | `nil`                                                                                                                                                                                                                |
| `apiServer.command`                               | Override default container command (useful when using custom images)                                | `["/bin/bash"]`                                                                                                                                                                                                      |
| `apiServer.args`                                  | Override default container args (useful when using custom images)                                   | `["-c","exec java -Xmx1024m -Dvertx.logger-delegate-factory-class-name=io.vertx.core.logging.Log4j2LogDelegateFactory -jar ./fatjar.jar  --host $$MY_POD_IP -c secrets/one-verticle-configs/config-apiserver.json"]` |
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
| `apiServer.extraEnvVarsCM`                        | Name of existing ConfigMap containing extra env vars for apiServer nodes                            | `gis-env`                                                                                                                                                                                                             |
| `apiServer.extraEnvVarsSecret`                    | Name of existing Secret containing extra env vars for apiServer nodes                               | `nil`                                                                                                                                                                                                                |
| `apiServer.extraVolumes`                          | Optionally specify extra list of additional volumes for the apiServer pod(s)                        | `nil`                                                                                                                                                                                                                |
| `apiServer.extraVolumeMounts`                     | Optionally specify extra list of additional volumeMounts for the apiServer container(s)             | `nil`                                                                                                                                                                                                                |
| `apiServer.sidecars`                              | Add additional sidecar containers to the apiServer pod(s)                                           | `{}`                                                                                                                                                                                                                 |
| `apiServer.initContainers`                        | Add additional init containers to the apiServer pod(s)                                              | `{}`                                                                                                                                                                                                                 |
| `apiServer.autoscaling.enabled`                   | Enable Horizontal POD autoscaling for Apache                                                        | `true`                                                                                                                                                                                                               |
| `apiServer.autoscaling.minReplicas`               | Minimum number of Apache replicas                                                                   | `1`                                                                                                                                                                                                                  |
| `apiServer.autoscaling.maxReplicas`               | Maximum number of Apache replicas                                                                   | `7`                                                                                                                                                                                                                  |
| `apiServer.autoscaling.targetCPU`                 | Target CPU utilization percentage                                                                   | `80`                                                                                                                                                                                                                 |
| `apiServer.autoscaling.targetMemory`              | Target Memory utilization percentage                                                                | `nil`                                                                                                                                                                                                                |

                               |


### Authenticator Parameters

| Name                                                  | Description                                                                                             | Value                                                                                                                                                                                                                     |
| ----------------------------------------------------- | ------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `authenticator.replicaCount`                          | Number of apiServer replicas to deploy                                                                  | `1`                                                                                                                                                                                                                       |
| `authenticator.livenessProbe.enabled`                 | Enable livenessProbe on authenticator containers                                                        | `true`                                                                                                                                                                                                                    |
| `authenticator.livenessProbe.initialDelaySeconds`     | Initial delay seconds for livenessProbe                                                                 | `60`                                                                                                                                                                                                                      |
| `authenticator.livenessProbe.periodSeconds`           | Period seconds for livenessProbe                                                                        | `60`                                                                                                                                                                                                                      |
| `authenticator.livenessProbe.timeoutSeconds`          | Timeout seconds for livenessProbe                                                                       | `10`                                                                                                                                                                                                                      |
| `authenticator.livenessProbe.failureThreshold`        | Failure threshold for livenessProbe                                                                     | `10`                                                                                                                                                                                                                      |
| `authenticator.livenessProbe.successThreshold`        | Success threshold for livenessProbe                                                                     | `10`                                                                                                                                                                                                                      |
| `authenticator.livenessProbe.path`                    | Path for httpGet                                                                                        | `/metrics`                                                                                                                                                                                                                |
| `authenticator.readinessProbe.enabled`                | Enable readinessProbe on authenticator containers                                                       | `false`                                                                                                                                                                                                                   |
| `authenticator.readinessProbe.initialDelaySeconds`    | Initial delay seconds for readinessProbe                                                                | `10`                                                                                                                                                                                                                      |
| `authenticator.readinessProbe.periodSeconds`          | Period seconds for readinessProbe                                                                       | `10`                                                                                                                                                                                                                      |
| `authenticator.readinessProbe.timeoutSeconds`         | Timeout seconds for readinessProbe                                                                      | `10`                                                                                                                                                                                                                      |
| `authenticator.readinessProbe.failureThreshold`       | Failure threshold for readinessProbe                                                                    | `10`                                                                                                                                                                                                                      |
| `authenticator.readinessProbe.successThreshold`       | Success threshold for readinessProbe                                                                    | `10`                                                                                                                                                                                                                      |
| `authenticator.startupProbe.enabled`                  | Enable startupProbe on authenticator containers                                                         | `false`                                                                                                                                                                                                                   |
| `authenticator.startupProbe.initialDelaySeconds`      | Initial delay seconds for startupProbe                                                                  | `10`                                                                                                                                                                                                                      |
| `authenticator.startupProbe.periodSeconds`            | Period seconds for startupProbe                                                                         | `10`                                                                                                                                                                                                                      |
| `authenticator.startupProbe.timeoutSeconds`           | Timeout seconds for startupProbe                                                                        | `10`                                                                                                                                                                                                                      |
| `authenticator.startupProbe.failureThreshold`         | Failure threshold for startupProbe                                                                      | `10`                                                                                                                                                                                                                      |
| `authenticator.startupProbe.successThreshold`         | Success threshold for startupProbe                                                                      | `10`                                                                                                                                                                                                                      |
| `authenticator.customLivenessProbe`                   | Custom livenessProbe that overrides the default one                                                     | `{}`                                                                                                                                                                                                                      |
| `authenticator.customReadinessProbe`                  | Custom readinessProbe that overrides the default one                                                    | `{}`                                                                                                                                                                                                                      |
| `authenticator.customStartupProbe`                    | Custom startupProbe that overrides the default one                                                      | `{}`                                                                                                                                                                                                                      |
| `authenticator.resources.limits`                      | The resources limits for the authenticator containers                                                   | `nil`                                                                                                                                                                                                                     |
| `authenticator.resources.requests`                    | The requested resources for the authenticator containers                                                | `nil`                                                                                                                                                                                                                     |
| `authenticator.podSecurityContext.enabled`            | Enabled authenticator pods' Security Context                                                            | `false`                                                                                                                                                                                                                   |
| `authenticator.podSecurityContext.fsGroup`            | Set authenticator pod's Security Context fsGroup                                                        | `1001`                                                                                                                                                                                                                    |
| `authenticator.containerSecurityContext.enabled`      | Enabled authenticator containers' Security Context                                                      | `false`                                                                                                                                                                                                                   |
| `authenticator.containerSecurityContext.runAsUser`    | Set authenticator containers' Security Context runAsUser                                                | `1001`                                                                                                                                                                                                                    |
| `authenticator.containerSecurityContext.runAsNonRoot` | Set authenticator containers' Security Context runAsNonRoot                                             | `true`                                                                                                                                                                                                                    |
| `authenticator.existingConfigmap`                     | The name of an existing ConfigMap with your custom configuration for authenticator                      | `nil`                                                                                                                                                                                                                     |
| `authenticator.command`                               | Override default container command (useful when using custom images)                                    | `["/bin/bash"]`                                                                                                                                                                                                           |
| `authenticator.args`                                  | Override default container args (useful when using custom images)                                       | `["-c","exec java -Xmx1024m -Dvertx.logger-delegate-factory-class-name=io.vertx.core.logging.Log4j2LogDelegateFactory  -jar ./fatjar.jar  --host $$MY_POD_IP -c secrets/one-verticle-configs/config-authenticator.json"]` |
| `authenticator.hostAliases`                           | apiServer pods host aliases                                                                             | `[]`                                                                                                                                                                                                                      |
| `authenticator.podLabels`                             | Extra labels for authenticator pods                                                                     | `{}`                                                                                                                                                                                                                      |
| `authenticator.podAffinityPreset`                     | Pod affinity preset. Ignored if `authenticator.affinity` is set. Allowed values: `soft` or `hard`       | `""`                                                                                                                                                                                                                      |
| `authenticator.podAntiAffinityPreset`                 | Pod anti-affinity preset. Ignored if `authenticator.affinity` is set. Allowed values: `soft` or `hard`  | `""`                                                                                                                                                                                                                      |
| `authenticator.nodeAffinityPreset.type`               | Node affinity preset type. Ignored if `authenticator.affinity` is set. Allowed values: `soft` or `hard` | `""`                                                                                                                                                                                                                      |
| `authenticator.nodeAffinityPreset.key`                | Node label key to match. Ignored if `authenticator.affinity` is set                                     | `""`                                                                                                                                                                                                                      |
| `authenticator.nodeAffinityPreset.values`             | Node label values to match. Ignored if `authenticator.affinity` is set                                  | `[]`                                                                                                                                                                                                                      |
| `authenticator.affinity`                              | Affinity for authenticator pods assignment                                                              | `{}`                                                                                                                                                                                                                      |
| `authenticator.nodeSelector`                          | Node labels for authenticator pods assignment                                                           | `nil`                                                                                                                                                                                                                     |
| `authenticator.tolerations`                           | Tolerations for authenticator pods assignment                                                           | `[]`                                                                                                                                                                                                                      |
| `authenticator.updateStrategy.type`                   | authenticator statefulset strategy type                                                                 | `RollingUpdate`                                                                                                                                                                                                           |
| `authenticator.priorityClassName`                     | authenticator pods' priorityClassName                                                                   | `""`                                                                                                                                                                                                                      |
| `authenticator.schedulerName`                         | Name of the k8s scheduler (other than default) for authenticator pods                                   | `""`                                                                                                                                                                                                                      |
| `authenticator.lifecycleHooks`                        | for the authenticator container(s) to automate configuration before or after startup                    | `{}`                                                                                                                                                                                                                      |
| `authenticator.extraEnvVars`                          | Array with extra environment variables to add to authenticator nodes                                    | `[]`                                                                                                                                                                                                                      |
| `authenticator.extraEnvVarsCM`                        | Name of existing ConfigMap containing extra env vars for authenticator nodes                            | `gis-env`                                                                                                                                                                                                                  |
| `authenticator.extraEnvVarsSecret`                    | Name of existing Secret containing extra env vars for authenticator nodes                               | `nil`                                                                                                                                                                                                                     |
| `authenticator.extraVolumes`                          | Optionally specify extra list of additional volumes for the authenticator pod(s)                        | `nil`                                                                                                                                                                                                                     |
| `authenticator.extraVolumeMounts`                     | Optionally specify extra list of additional volumeMounts for the authenticator container(s)             | `nil`                                                                                                                                                                                                                     |
| `authenticator.sidecars`                              | Add additional sidecar containers to the authenticator pod(s)                                           | `{}`                                                                                                                                                                                                                      |
| `authenticator.initContainers`                        | Add additional init containers to the authenticator pod(s)                                              | `{}`                                                                                                                                                                                                                      |
| `authenticator.autoscaling.enabled`                   | Enable Horizontal POD autoscaling for Apache                                                            | `true`                                                                                                                                                                                                                    |
| `authenticator.autoscaling.minReplicas`               | Minimum number of Apache replicas                                                                       | `1`                                                                                                                                                                                                                       |
| `authenticator.autoscaling.maxReplicas`               | Maximum number of Apache replicas                                                                       | `5`                                                                                                                                                                                                                       |
| `authenticator.autoscaling.targetCPU`                 | Target CPU utilization percentage                                                                       | `80`                                                                                                                                                                                                                      |
| `authenticator.autoscaling.targetMemory`              | Target Memory utilization percentage                                                                    | `nil`                                                                                                                                                                                                                     |


### Metering Parameters

| Name                                             | Description                                                                                        | Value                                                                                                                                                                                                                |
| ------------------------------------------------ | -------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `metering.replicaCount`                          | Number of apiServer replicas to deploy                                                             | `1`                                                                                                                                                                                                                  |
| `metering.livenessProbe.enabled`                 | Enable livenessProbe on metering containers                                                        | `true`                                                                                                                                                                                                               |
| `metering.livenessProbe.initialDelaySeconds`     | Initial delay seconds for livenessProbe                                                            | `60`                                                                                                                                                                                                                 |
| `metering.livenessProbe.periodSeconds`           | Period seconds for livenessProbe                                                                   | `60`                                                                                                                                                                                                                 |
| `metering.livenessProbe.timeoutSeconds`          | Timeout seconds for livenessProbe                                                                  | `10`                                                                                                                                                                                                                 |
| `metering.livenessProbe.failureThreshold`        | Failure threshold for livenessProbe                                                                | `10`                                                                                                                                                                                                                 |
| `metering.livenessProbe.successThreshold`        | Success threshold for livenessProbe                                                                | `10`                                                                                                                                                                                                                 |
| `metering.livenessProbe.path`                    | Path for httpGet                                                                                   | `/metrics`                                                                                                                                                                                                           |
| `metering.readinessProbe.enabled`                | Enable readinessProbe on metering containers                                                       | `false`                                                                                                                                                                                                              |
| `metering.readinessProbe.initialDelaySeconds`    | Initial delay seconds for readinessProbe                                                           | `10`                                                                                                                                                                                                                 |
| `metering.readinessProbe.periodSeconds`          | Period seconds for readinessProbe                                                                  | `10`                                                                                                                                                                                                                 |
| `metering.readinessProbe.timeoutSeconds`         | Timeout seconds for readinessProbe                                                                 | `10`                                                                                                                                                                                                                 |
| `metering.readinessProbe.failureThreshold`       | Failure threshold for readinessProbe                                                               | `10`                                                                                                                                                                                                                 |
| `metering.readinessProbe.successThreshold`       | Success threshold for readinessProbe                                                               | `10`                                                                                                                                                                                                                 |
| `metering.startupProbe.enabled`                  | Enable startupProbe on metering containers                                                         | `false`                                                                                                                                                                                                              |
| `metering.startupProbe.initialDelaySeconds`      | Initial delay seconds for startupProbe                                                             | `10`                                                                                                                                                                                                                 |
| `metering.startupProbe.periodSeconds`            | Period seconds for startupProbe                                                                    | `10`                                                                                                                                                                                                                 |
| `metering.startupProbe.timeoutSeconds`           | Timeout seconds for startupProbe                                                                   | `10`                                                                                                                                                                                                                 |
| `metering.startupProbe.failureThreshold`         | Failure threshold for startupProbe                                                                 | `10`                                                                                                                                                                                                                 |
| `metering.startupProbe.successThreshold`         | Success threshold for startupProbe                                                                 | `10`                                                                                                                                                                                                                 |
| `metering.customLivenessProbe`                   | Custom livenessProbe that overrides the default one                                                | `{}`                                                                                                                                                                                                                 |
| `metering.customReadinessProbe`                  | Custom readinessProbe that overrides the default one                                               | `{}`                                                                                                                                                                                                                 |
| `metering.customStartupProbe`                    | Custom startupProbe that overrides the default one                                                 | `{}`                                                                                                                                                                                                                 |
| `metering.resources.limits`                      | The resources limits for the metering containers                                                   | `nil`                                                                                                                                                                                                                |
| `metering.resources.requests`                    | The requested resources for the metering containers                                                | `nil`                                                                                                                                                                                                                |
| `metering.podSecurityContext.enabled`            | Enabled metering pods' Security Context                                                            | `false`                                                                                                                                                                                                              |
| `metering.podSecurityContext.fsGroup`            | Set metering pod's Security Context fsGroup                                                        | `1001`                                                                                                                                                                                                               |
| `metering.containerSecurityContext.enabled`      | Enabled metering containers' Security Context                                                      | `false`                                                                                                                                                                                                              |
| `metering.containerSecurityContext.runAsUser`    | Set metering containers' Security Context runAsUser                                                | `1001`                                                                                                                                                                                                               |
| `metering.containerSecurityContext.runAsNonRoot` | Set metering containers' Security Context runAsNonRoot                                             | `true`                                                                                                                                                                                                               |
| `metering.existingConfigmap`                     | The name of an existing ConfigMap with your custom configuration for metering                      | `nil`                                                                                                                                                                                                                |
| `metering.command`                               | Override default container command (useful when using custom images)                               | `["/bin/bash"]`                                                                                                                                                                                                      |
| `metering.args`                                  | Override default container args (useful when using custom images)                                  | `["-c","exec java -Xmx1024m -Dvertx.logger-delegate-factory-class-name=io.vertx.core.logging.Log4j2LogDelegateFactory  -jar ./fatjar.jar  --host $$MY_POD_IP -c secrets/one-verticle-configs/config-metering.json"]` |
| `metering.hostAliases`                           | apiServer pods host aliases                                                                        | `[]`                                                                                                                                                                                                                 |
| `metering.podLabels`                             | Extra labels for metering pods                                                                     | `{}`                                                                                                                                                                                                                 |
| `metering.podAffinityPreset`                     | Pod affinity preset. Ignored if `metering.affinity` is set. Allowed values: `soft` or `hard`       | `""`                                                                                                                                                                                                                 |
| `metering.podAntiAffinityPreset`                 | Pod anti-affinity preset. Ignored if `metering.affinity` is set. Allowed values: `soft` or `hard`  | `""`                                                                                                                                                                                                                 |
| `metering.nodeAffinityPreset.type`               | Node affinity preset type. Ignored if `metering.affinity` is set. Allowed values: `soft` or `hard` | `""`                                                                                                                                                                                                                 |
| `metering.nodeAffinityPreset.key`                | Node label key to match. Ignored if `metering.affinity` is set                                     | `""`                                                                                                                                                                                                                 |
| `metering.nodeAffinityPreset.values`             | Node label values to match. Ignored if `metering.affinity` is set                                  | `[]`                                                                                                                                                                                                                 |
| `metering.affinity`                              | Affinity for metering pods assignment                                                              | `{}`                                                                                                                                                                                                                 |
| `metering.nodeSelector`                          | Node labels for metering pods assignment                                                           | `nil`                                                                                                                                                                                                                |
| `metering.tolerations`                           | Tolerations for metering pods assignment                                                           | `[]`                                                                                                                                                                                                                 |
| `metering.updateStrategy.type`                   | metering statefulset strategy type                                                                 | `RollingUpdate`                                                                                                                                                                                                      |
| `metering.priorityClassName`                     | metering pods' priorityClassName                                                                   | `""`                                                                                                                                                                                                                 |
| `metering.schedulerName`                         | Name of the k8s scheduler (other than default) for metering pods                                   | `""`                                                                                                                                                                                                                 |
| `metering.lifecycleHooks`                        | for the metering container(s) to automate configuration before or after startup                    | `{}`                                                                                                                                                                                                                 |
| `metering.extraEnvVars`                          | Array with extra environment variables to add to metering nodes                                    | `[]`                                                                                                                                                                                                                 |
| `metering.extraEnvVarsCM`                        | Name of existing ConfigMap containing extra env vars for metering nodes                            | `gis-env`                                                                                                                                                                                                             |
| `metering.extraEnvVarsSecret`                    | Name of existing Secret containing extra env vars for metering nodes                               | `nil`                                                                                                                                                                                                                |
| `metering.extraVolumes`                          | Optionally specify extra list of additional volumes for the metering pod(s)                        | `nil`                                                                                                                                                                                                                |
| `metering.extraVolumeMounts`                     | Optionally specify extra list of additional volumeMounts for the metering container(s)             | `nil`                                                                                                                                                                                                                |
| `metering.sidecars`                              | Add additional sidecar containers to the metering pod(s)                                           | `{}`                                                                                                                                                                                                                 |
| `metering.initContainers`                        | Add additional init containers to the metering pod(s)                                              | `{}`                                                                                                                                                                                                                 |
| `metering.autoscaling.enabled`                   | Enable Horizontal POD autoscaling for Apache                                                       | `true`                                                                                                                                                                                                               |
| `metering.autoscaling.minReplicas`               | Minimum number of Apache replicas                                                                  | `1`                                                                                                                                                                                                                  |
| `metering.autoscaling.maxReplicas`               | Maximum number of Apache replicas                                                                  | `5`                                                                                                                                                                                                                  |
| `metering.autoscaling.targetCPU`                 | Target CPU utilization percentage                                                                  | `80`                                                                                                                                                                                                                 |
| `metering.autoscaling.targetMemory`              | Target Memory utilization percentage                                                               | `nil`                                                                                                                                                                                                                |


### Traffic Exposure Parameters

| Name                               | Description                                                                                                                      | Value                    |
| ---------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `service.type`                     | ApiServers ervice type                                                                                                           | `ClusterIP`              |
| `service.ports`                    | ApiServer service port                                                                                                           | `80`                     |
| `service.targetPorts`              | ApiServer service TargetPorts port                                                                                               | `80`                     |
| `service.clusterIP`                | ApiServer service Cluster IP                                                                                                     | `nil`                    |
| `service.loadBalancerIP`           | apiServer service Load Balancer IP                                                                                               | `nil`                    |
| `service.loadBalancerSourceRanges` | apiServer service Load Balancer sources                                                                                          | `[]`                     |
| `service.externalTrafficPolicy`    | apiServer service external traffic policy                                                                                        | `Cluster`                |
| `service.annotations`              | Additional custom annotations for apiServer service                                                                              | `{}`                     |
| `service.extraPorts`               | Extra ports to expose in apiServer service (normally used with the `sidecars` value)                                             | `[]`                     |
| `ingress.enabled`                  | Enable ingress record generation for apiServer                                                                                   | `true`                   |
| `ingress.pathType`                 | Ingress path type                                                                                                                | `ImplementationSpecific` |
| `ingress.apiVersion`               | Force Ingress API version (automatically detected if not set)                                                                    | `nil`                    |
| `ingress.hostname`                 | Default host for the ingress record                                                                                              | `di.iudx.org.in`         |
| `ingress.path`                     | Default path for the ingress record                                                                                              | `/`                      |
| `ingress.annotations`              | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}`                     |
| `ingress.serviceName`              | Backend ingress Service Name                                                                                                     | `gis-api-server`          |
| `ingress.tls.secretName`                      | TLS secret name, if certmanager is used, no need to create that secret with tls certificates else create secret using the command `kubectl create secret tls gis-tls-secret --key ./secrets/pki/privkey.pem --cert ./secrets/pki/fullchain.pem -n gis`                                                    | `gis-tls-secret`                    |
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

| Name                    | Description                                          | Value   |
| ----------------------- | ---------------------------------------------------- | ------- |
| `serviceAccount.create` | Specifies whether a ServiceAccount should be created | `false` |
| `serviceAccount.name`   | The name of the ServiceAccount to use.               | `""`    |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install gis-interface gis-interface \  -n gis
  --set=slack.channel="#bots",slack.token="XXXX-XXXX-XXXX"
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
 helm install gis-interface -f values.yaml gis-interface/ -n gis
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

As an alternative, you can use of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters

## Troubleshooting

Find more information about how to deal with common errors related to Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).


