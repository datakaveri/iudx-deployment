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


### Processor Parameters

| Name                                              | Description                                                                                         | Value                                                                                                                                                                                                                 |
| ------------------------------------------------- | --------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `processor.replicaCount`                          | Number of processor replicas to deploy                                                              | `1`                                                                                                                                                                                                                   |
| `processor.livenessProbe.enabled`                 | Enable livenessProbe on processor containers                                                        | `true`                                                                                                                                                                                                                |
| `processor.livenessProbe.initialDelaySeconds`     | Initial delay seconds for livenessProbe                                                             | `60`                                                                                                                                                                                                                  |
| `processor.livenessProbe.periodSeconds`           | Period seconds for livenessProbe                                                                    | `60`                                                                                                                                                                                                                  |
| `processor.livenessProbe.timeoutSeconds`          | Timeout seconds for livenessProbe                                                                   | `10`                                                                                                                                                                                                                  |
| `processor.livenessProbe.failureThreshold`        | Failure threshold for livenessProbe                                                                 | `10`                                                                                                                                                                                                                  |
| `processor.livenessProbe.successThreshold`        | Success threshold for livenessProbe                                                                 | `10`                                                                                                                                                                                                                  |
| `processor.livenessProbe.path`                    | Path for httpGet                                                                                    | `/metrics`                                                                                                                                                                                                            |
| `processor.readinessProbe.enabled`                | Enable readinessProbe on processor containers                                                       | `false`                                                                                                                                                                                                               |
| `processor.readinessProbe.initialDelaySeconds`    | Initial delay seconds for readinessProbe                                                            | `10`                                                                                                                                                                                                                  |
| `processor.readinessProbe.periodSeconds`          | Period seconds for readinessProbe                                                                   | `10`                                                                                                                                                                                                                  |
| `processor.readinessProbe.timeoutSeconds`         | Timeout seconds for readinessProbe                                                                  | `10`                                                                                                                                                                                                                  |
| `processor.readinessProbe.failureThreshold`       | Failure threshold for readinessProbe                                                                | `10`                                                                                                                                                                                                                  |
| `processor.readinessProbe.successThreshold`       | Success threshold for readinessProbe                                                                | `10`                                                                                                                                                                                                                  |
| `processor.startupProbe.enabled`                  | Enable startupProbe on processor containers                                                         | `false`                                                                                                                                                                                                               |
| `processor.startupProbe.initialDelaySeconds`      | Initial delay seconds for startupProbe                                                              | `10`                                                                                                                                                                                                                  |
| `processor.startupProbe.periodSeconds`            | Period seconds for startupProbe                                                                     | `10`                                                                                                                                                                                                                  |
| `processor.startupProbe.timeoutSeconds`           | Timeout seconds for startupProbe                                                                    | `10`                                                                                                                                                                                                                  |
| `processor.startupProbe.failureThreshold`         | Failure threshold for startupProbe                                                                  | `10`                                                                                                                                                                                                                  |
| `processor.startupProbe.successThreshold`         | Success threshold for startupProbe                                                                  | `10`                                                                                                                                                                                                                  |
| `processor.customLivenessProbe`                   | Custom livenessProbe that overrides the default one                                                 | `{}`                                                                                                                                                                                                                  |
| `processor.customReadinessProbe`                  | Custom readinessProbe that overrides the default one                                                | `{}`                                                                                                                                                                                                                  |
| `processor.customStartupProbe`                    | Custom startupProbe that overrides the default one                                                  | `{}`                                                                                                                                                                                                                  |
| `processor.resources.limits`                      | The resources limits for the processor containers                                                   | `{}`                                                                                                                                                                                                                  |
| `processor.resources.requests`                    | The requested resources for the processor containers                                                | `{}`                                                                                                                                                                                                                  |
| `processor.podSecurityContext.enabled`            | Enabled processor pods' Security Context                                                            | `false`                                                                                                                                                                                                               |
| `processor.podSecurityContext.fsGroup`            | Set processor pod's Security Context fsGroup                                                        | `1001`                                                                                                                                                                                                                |
| `processor.containerSecurityContext.enabled`      | Enabled processor containers' Security Context                                                      | `false`                                                                                                                                                                                                               |
| `processor.containerSecurityContext.runAsUser`    | Set processor containers' Security Context runAsUser                                                | `1001`                                                                                                                                                                                                                |
| `processor.containerSecurityContext.runAsNonRoot` | Set processor containers' Security Context runAsNonRoot                                             | `true`                                                                                                                                                                                                                |
| `processor.existingConfigmap`                     | The name of an existing ConfigMap with your custom configuration for processor                      | `nil`                                                                                                                                                                                                                 |
| `processor.command`                               | Override default container command (useful when using custom images)                                | `["/bin/bash"]`                                                                                                                                                                                                       |
| `processor.args`                                  | Override default container args (useful when using custom images)                                   | `["-c","exec java -Xmx1024m -Dvertx.logger-delegate-factory-class-name=io.vertx.core.logging.Log4j2LogDelegateFactory  -jar ./fatjar.jar  --host $$MY_POD_IP -c secrets/one-verticle-configs/config-processor.json"]` |
| `processor.hostAliases`                           | redis pods host aliases                                                                             | `[]`                                                                                                                                                                                                                  |
| `processor.podLabels`                             | Extra labels for processor pods                                                                     | `{}`                                                                                                                                                                                                                  |
| `processor.podAffinityPreset`                     | Pod affinity preset. Ignored if `processor.affinity` is set. Allowed values: `soft` or `hard`       | `""`                                                                                                                                                                                                                  |
| `processor.podAntiAffinityPreset`                 | Pod anti-affinity preset. Ignored if `processor.affinity` is set. Allowed values: `soft` or `hard`  | `""`                                                                                                                                                                                                                  |
| `processor.nodeAffinityPreset.type`               | Node affinity preset type. Ignored if `processor.affinity` is set. Allowed values: `soft` or `hard` | `""`                                                                                                                                                                                                                  |
| `processor.nodeAffinityPreset.key`                | Node label key to match. Ignored if `processor.affinity` is set                                     | `""`                                                                                                                                                                                                                  |
| `processor.nodeAffinityPreset.values`             | Node label values to match. Ignored if `processor.affinity` is set                                  | `[]`                                                                                                                                                                                                                  |
| `processor.affinity`                              | Affinity for processor pods assignment                                                              | `{}`                                                                                                                                                                                                                  |
| `processor.nodeSelector`                          | Node labels for processor pods assignment                                                           | `nil`                                                                                                                                                                                                                 |
| `processor.tolerations`                           | Tolerations for processor pods assignment                                                           | `[]`                                                                                                                                                                                                                  |
| `processor.updateStrategy.type`                   | processor statefulset strategy type                                                                 | `RollingUpdate`                                                                                                                                                                                                       |
| `processor.priorityClassName`                     | processor pods' priorityClassName                                                                   | `""`                                                                                                                                                                                                                  |
| `processor.schedulerName`                         | Name of the k8s scheduler (other than default) for processor pods                                   | `""`                                                                                                                                                                                                                  |
| `processor.lifecycleHooks`                        | for the processor container(s) to automate configuration before or after startup                    | `{}`                                                                                                                                                                                                                  |
| `processor.extraEnvVars`                          | Array with extra environment variables to add to processor nodes                                    | `[]`                                                                                                                                                                                                                  |
| `processor.extraEnvVarsCM`                        | Name of existing ConfigMap containing extra env vars for processor nodes                            | `lip-env`                                                                                                                                                                                                             |
| `processor.extraEnvVarsSecret`                    | Name of existing Secret containing extra env vars for processor nodes                               | `nil`                                                                                                                                                                                                                 |
| `processor.extraVolumes`                          | Optionally specify extra list of additional volumes for the processor pod(s)                        | `nil`                                                                                                                                                                                                                 |
| `processor.extraVolumeMounts`                     | Optionally specify extra list of additional volumeMounts for the processor container(s)             | `nil`                                                                                                                                                                                                                 |
| `processor.sidecars`                              | Add additional sidecar containers to the processor pod(s)                                           | `{}`                                                                                                                                                                                                                  |
| `processor.initContainers`                        | Add additional init containers to the processor pod(s)                                              | `{}`                                                                                                                                                                                                                  |
| `processor.autoscaling.enabled`                   | Enable Horizontal POD autoscaling for Apache                                                        | `true`                                                                                                                                                                                                                |
| `processor.autoscaling.minReplicas`               | Minimum number of Apache replicas                                                                   | `1`                                                                                                                                                                                                                   |
| `processor.autoscaling.maxReplicas`               | Maximum number of Apache replicas                                                                   | `5`                                                                                                                                                                                                                   |
| `processor.autoscaling.targetCPU`                 | Target CPU utilization percentage                                                                   | `80`                                                                                                                                                                                                                  |
| `processor.autoscaling.targetMemory`              | Target Memory utilization percentage                                                                | `nil`                                                                                                                                                                                                                 |


### Rabbitmq Parameters

| Name                                             | Description                                                                                        | Value                                                                                                                                                                                                                |
| ------------------------------------------------ | -------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `rabbitmq.replicaCount`                          | Number of rabbitmq replicas to deploy                                                              | `1`                                                                                                                                                                                                                  |
| `rabbitmq.livenessProbe.enabled`                 | Enable livenessProbe on rabbitmq containers                                                        | `true`                                                                                                                                                                                                               |
| `rabbitmq.livenessProbe.initialDelaySeconds`     | Initial delay seconds for livenessProbe                                                            | `60`                                                                                                                                                                                                                 |
| `rabbitmq.livenessProbe.periodSeconds`           | Period seconds for livenessProbe                                                                   | `60`                                                                                                                                                                                                                 |
| `rabbitmq.livenessProbe.timeoutSeconds`          | Timeout seconds for livenessProbe                                                                  | `10`                                                                                                                                                                                                                 |
| `rabbitmq.livenessProbe.failureThreshold`        | Failure threshold for livenessProbe                                                                | `10`                                                                                                                                                                                                                 |
| `rabbitmq.livenessProbe.successThreshold`        | Success threshold for livenessProbe                                                                | `10`                                                                                                                                                                                                                 |
| `rabbitmq.livenessProbe.path`                    | Path for httpGet                                                                                   | `/metrics`                                                                                                                                                                                                           |
| `rabbitmq.readinessProbe.enabled`                | Enable readinessProbe on rabbitmq containers                                                       | `false`                                                                                                                                                                                                              |
| `rabbitmq.readinessProbe.initialDelaySeconds`    | Initial delay seconds for readinessProbe                                                           | `10`                                                                                                                                                                                                                 |
| `rabbitmq.readinessProbe.periodSeconds`          | Period seconds for readinessProbe                                                                  | `10`                                                                                                                                                                                                                 |
| `rabbitmq.readinessProbe.timeoutSeconds`         | Timeout seconds for readinessProbe                                                                 | `10`                                                                                                                                                                                                                 |
| `rabbitmq.readinessProbe.failureThreshold`       | Failure threshold for readinessProbe                                                               | `10`                                                                                                                                                                                                                 |
| `rabbitmq.readinessProbe.successThreshold`       | Success threshold for readinessProbe                                                               | `10`                                                                                                                                                                                                                 |
| `rabbitmq.startupProbe.enabled`                  | Enable startupProbe on rabbitmq containers                                                         | `false`                                                                                                                                                                                                              |
| `rabbitmq.startupProbe.initialDelaySeconds`      | Initial delay seconds for startupProbe                                                             | `10`                                                                                                                                                                                                                 |
| `rabbitmq.startupProbe.periodSeconds`            | Period seconds for startupProbe                                                                    | `10`                                                                                                                                                                                                                 |
| `rabbitmq.startupProbe.timeoutSeconds`           | Timeout seconds for startupProbe                                                                   | `10`                                                                                                                                                                                                                 |
| `rabbitmq.startupProbe.failureThreshold`         | Failure threshold for startupProbe                                                                 | `10`                                                                                                                                                                                                                 |
| `rabbitmq.startupProbe.successThreshold`         | Success threshold for startupProbe                                                                 | `10`                                                                                                                                                                                                                 |
| `rabbitmq.customLivenessProbe`                   | Custom livenessProbe that overrides the default one                                                | `{}`                                                                                                                                                                                                                 |
| `rabbitmq.customReadinessProbe`                  | Custom readinessProbe that overrides the default one                                               | `{}`                                                                                                                                                                                                                 |
| `rabbitmq.customStartupProbe`                    | Custom startupProbe that overrides the default one                                                 | `{}`                                                                                                                                                                                                                 |
| `rabbitmq.resources.limits`                      | The resources limits for the rabbitmq containers                                                   | `{}`                                                                                                                                                                                                                 |
| `rabbitmq.resources.requests`                    | The requested resources for the rabbitmq containers                                                | `{}`                                                                                                                                                                                                                 |
| `rabbitmq.podSecurityContext.enabled`            | Enabled rabbitmq pods' Security Context                                                            | `false`                                                                                                                                                                                                              |
| `rabbitmq.podSecurityContext.fsGroup`            | Set rabbitmq pod's Security Context fsGroup                                                        | `1001`                                                                                                                                                                                                               |
| `rabbitmq.containerSecurityContext.enabled`      | Enabled rabbitmq containers' Security Context                                                      | `false`                                                                                                                                                                                                              |
| `rabbitmq.containerSecurityContext.runAsUser`    | Set rabbitmq containers' Security Context runAsUser                                                | `1001`                                                                                                                                                                                                               |
| `rabbitmq.containerSecurityContext.runAsNonRoot` | Set rabbitmq containers' Security Context runAsNonRoot                                             | `true`                                                                                                                                                                                                               |
| `rabbitmq.existingConfigmap`                     | The name of an existing ConfigMap with your custom configuration for rabbitmq                      | `nil`                                                                                                                                                                                                                |
| `rabbitmq.command`                               | Override default container command (useful when using custom images)                               | `["/bin/bash"]`                                                                                                                                                                                                      |
| `rabbitmq.args`                                  | Override default container args (useful when using custom images)                                  | `["-c","exec java -Xmx1024m -Dvertx.logger-delegate-factory-class-name=io.vertx.core.logging.Log4j2LogDelegateFactory  -jar ./fatjar.jar  --host $$MY_POD_IP -c secrets/one-verticle-configs/config-rabbitmq.json"]` |
| `rabbitmq.hostAliases`                           | redis pods host aliases                                                                            | `[]`                                                                                                                                                                                                                 |
| `rabbitmq.podLabels`                             | Extra labels for rabbitmq pods                                                                     | `{}`                                                                                                                                                                                                                 |
| `rabbitmq.podAffinityPreset`                     | Pod affinity preset. Ignored if `rabbitmq.affinity` is set. Allowed values: `soft` or `hard`       | `""`                                                                                                                                                                                                                 |
| `rabbitmq.podAntiAffinityPreset`                 | Pod anti-affinity preset. Ignored if `rabbitmq.affinity` is set. Allowed values: `soft` or `hard`  | `""`                                                                                                                                                                                                                 |
| `rabbitmq.nodeAffinityPreset.type`               | Node affinity preset type. Ignored if `rabbitmq.affinity` is set. Allowed values: `soft` or `hard` | `""`                                                                                                                                                                                                                 |
| `rabbitmq.nodeAffinityPreset.key`                | Node label key to match. Ignored if `rabbitmq.affinity` is set                                     | `""`                                                                                                                                                                                                                 |
| `rabbitmq.nodeAffinityPreset.values`             | Node label values to match. Ignored if `rabbitmq.affinity` is set                                  | `[]`                                                                                                                                                                                                                 |
| `rabbitmq.affinity`                              | Affinity for rabbitmq pods assignment                                                              | `{}`                                                                                                                                                                                                                 |
| `rabbitmq.nodeSelector`                          | Node labels for rabbitmq pods assignment                                                           | `nil`                                                                                                                                                                                                                |
| `rabbitmq.tolerations`                           | Tolerations for rabbitmq pods assignment                                                           | `[]`                                                                                                                                                                                                                 |
| `rabbitmq.updateStrategy.type`                   | rabbitmq statefulset strategy type                                                                 | `RollingUpdate`                                                                                                                                                                                                      |
| `rabbitmq.priorityClassName`                     | rabbitmq pods' priorityClassName                                                                   | `""`                                                                                                                                                                                                                 |
| `rabbitmq.schedulerName`                         | Name of the k8s scheduler (other than default) for rabbitmq pods                                   | `""`                                                                                                                                                                                                                 |
| `rabbitmq.lifecycleHooks`                        | for the rabbitmq container(s) to automate configuration before or after startup                    | `{}`                                                                                                                                                                                                                 |
| `rabbitmq.extraEnvVars`                          | Array with extra environment variables to add to rabbitmq nodes                                    | `[]`                                                                                                                                                                                                                 |
| `rabbitmq.extraEnvVarsCM`                        | Name of existing ConfigMap containing extra env vars for rabbitmq nodes                            | `lip-env`                                                                                                                                                                                                            |
| `rabbitmq.extraEnvVarsSecret`                    | Name of existing Secret containing extra env vars for rabbitmq nodes                               | `nil`                                                                                                                                                                                                                |
| `rabbitmq.extraVolumes`                          | Optionally specify extra list of additional volumes for the rabbitmq pod(s)                        | `nil`                                                                                                                                                                                                                |
| `rabbitmq.extraVolumeMounts`                     | Optionally specify extra list of additional volumeMounts for the rabbitmq container(s)             | `nil`                                                                                                                                                                                                                |
| `rabbitmq.sidecars`                              | Add additional sidecar containers to the rabbitmq pod(s)                                           | `{}`                                                                                                                                                                                                                 |
| `rabbitmq.initContainers`                        | Add additional init containers to the rabbitmq pod(s)                                              | `{}`                                                                                                                                                                                                                 |
| `rabbitmq.autoscaling.enabled`                   | Enable Horizontal POD autoscaling for Apache                                                       | `true`                                                                                                                                                                                                               |
| `rabbitmq.autoscaling.minReplicas`               | Minimum number of Apache replicas                                                                  | `1`                                                                                                                                                                                                                  |
| `rabbitmq.autoscaling.maxReplicas`               | Maximum number of Apache replicas                                                                  | `5`                                                                                                                                                                                                                  |
| `rabbitmq.autoscaling.targetCPU`                 | Target CPU utilization percentage                                                                  | `80`                                                                                                                                                                                                                 |
| `rabbitmq.autoscaling.targetMemory`              | Target Memory utilization percentage                                                               | `nil`                                                                                                                                                                                                                |


### Redis Parameters

| Name                                          | Description                                                                                     | Value                                                                                                                                                                                                             |
| --------------------------------------------- | ----------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `redis.replicaCount`                          | Number of redis replicas to deploy                                                              | `1`                                                                                                                                                                                                               |
| `redis.livenessProbe.enabled`                 | Enable livenessProbe on redis containers                                                        | `true`                                                                                                                                                                                                            |
| `redis.livenessProbe.initialDelaySeconds`     | Initial delay seconds for livenessProbe                                                         | `60`                                                                                                                                                                                                              |
| `redis.livenessProbe.periodSeconds`           | Period seconds for livenessProbe                                                                | `60`                                                                                                                                                                                                              |
| `redis.livenessProbe.timeoutSeconds`          | Timeout seconds for livenessProbe                                                               | `10`                                                                                                                                                                                                              |
| `redis.livenessProbe.failureThreshold`        | Failure threshold for livenessProbe                                                             | `10`                                                                                                                                                                                                              |
| `redis.livenessProbe.successThreshold`        | Success threshold for livenessProbe                                                             | `10`                                                                                                                                                                                                              |
| `redis.livenessProbe.path`                    | Path for httpGet                                                                                | `/metrics`                                                                                                                                                                                                        |
| `redis.readinessProbe.enabled`                | Enable readinessProbe on redis containers                                                       | `false`                                                                                                                                                                                                           |
| `redis.readinessProbe.initialDelaySeconds`    | Initial delay seconds for readinessProbe                                                        | `10`                                                                                                                                                                                                              |
| `redis.readinessProbe.periodSeconds`          | Period seconds for readinessProbe                                                               | `10`                                                                                                                                                                                                              |
| `redis.readinessProbe.timeoutSeconds`         | Timeout seconds for readinessProbe                                                              | `10`                                                                                                                                                                                                              |
| `redis.readinessProbe.failureThreshold`       | Failure threshold for readinessProbe                                                            | `10`                                                                                                                                                                                                              |
| `redis.readinessProbe.successThreshold`       | Success threshold for readinessProbe                                                            | `10`                                                                                                                                                                                                              |
| `redis.startupProbe.enabled`                  | Enable startupProbe on redis containers                                                         | `false`                                                                                                                                                                                                           |
| `redis.startupProbe.initialDelaySeconds`      | Initial delay seconds for startupProbe                                                          | `10`                                                                                                                                                                                                              |
| `redis.startupProbe.periodSeconds`            | Period seconds for startupProbe                                                                 | `10`                                                                                                                                                                                                              |
| `redis.startupProbe.timeoutSeconds`           | Timeout seconds for startupProbe                                                                | `10`                                                                                                                                                                                                              |
| `redis.startupProbe.failureThreshold`         | Failure threshold for startupProbe                                                              | `10`                                                                                                                                                                                                              |
| `redis.startupProbe.successThreshold`         | Success threshold for startupProbe                                                              | `10`                                                                                                                                                                                                              |
| `redis.customLivenessProbe`                   | Custom livenessProbe that overrides the default one                                             | `{}`                                                                                                                                                                                                              |
| `redis.customReadinessProbe`                  | Custom readinessProbe that overrides the default one                                            | `{}`                                                                                                                                                                                                              |
| `redis.customStartupProbe`                    | Custom startupProbe that overrides the default one                                              | `{}`                                                                                                                                                                                                              |
| `redis.resources.limits`                      | The resources limits for the redis containers                                                   | `{}`                                                                                                                                                                                                              |
| `redis.resources.requests`                    | The requested resources for the redis containers                                                | `{}`                                                                                                                                                                                                              |
| `redis.podSecurityContext.enabled`            | Enabled redis pods' Security Context                                                            | `false`                                                                                                                                                                                                           |
| `redis.podSecurityContext.fsGroup`            | Set redis pod's Security Context fsGroup                                                        | `1001`                                                                                                                                                                                                            |
| `redis.containerSecurityContext.enabled`      | Enabled redis containers' Security Context                                                      | `false`                                                                                                                                                                                                           |
| `redis.containerSecurityContext.runAsUser`    | Set redis containers' Security Context runAsUser                                                | `1001`                                                                                                                                                                                                            |
| `redis.containerSecurityContext.runAsNonRoot` | Set redis containers' Security Context runAsNonRoot                                             | `true`                                                                                                                                                                                                            |
| `redis.existingConfigmap`                     | The name of an existing ConfigMap with your custom configuration for redis                      | `nil`                                                                                                                                                                                                             |
| `redis.command`                               | Override default container command (useful when using custom images)                            | `["/bin/bash"]`                                                                                                                                                                                                   |
| `redis.args`                                  | Override default container args (useful when using custom images)                               | `["-c","exec java -Xmx1024m -Dvertx.logger-delegate-factory-class-name=io.vertx.core.logging.Log4j2LogDelegateFactory  -jar ./fatjar.jar  --host $$MY_POD_IP -c secrets/one-verticle-configs/config-redis.json"]` |
| `redis.hostAliases`                           | redis pods host aliases                                                                         | `[]`                                                                                                                                                                                                              |
| `redis.podLabels`                             | Extra labels for redis pods                                                                     | `{}`                                                                                                                                                                                                              |
| `redis.podAffinityPreset`                     | Pod affinity preset. Ignored if `redis.affinity` is set. Allowed values: `soft` or `hard`       | `""`                                                                                                                                                                                                              |
| `redis.podAntiAffinityPreset`                 | Pod anti-affinity preset. Ignored if `redis.affinity` is set. Allowed values: `soft` or `hard`  | `""`                                                                                                                                                                                                              |
| `redis.nodeAffinityPreset.type`               | Node affinity preset type. Ignored if `redis.affinity` is set. Allowed values: `soft` or `hard` | `""`                                                                                                                                                                                                              |
| `redis.nodeAffinityPreset.key`                | Node label key to match. Ignored if `redis.affinity` is set                                     | `""`                                                                                                                                                                                                              |
| `redis.nodeAffinityPreset.values`             | Node label values to match. Ignored if `redis.affinity` is set                                  | `[]`                                                                                                                                                                                                              |
| `redis.affinity`                              | Affinity for redis pods assignment                                                              | `{}`                                                                                                                                                                                                              |
| `redis.nodeSelector`                          | Node labels for redis pods assignment                                                           | `nil`                                                                                                                                                                                                             |
| `redis.tolerations`                           | Tolerations for redis pods assignment                                                           | `[]`                                                                                                                                                                                                              |
| `redis.updateStrategy.type`                   | redis statefulset strategy type                                                                 | `RollingUpdate`                                                                                                                                                                                                   |
| `redis.priorityClassName`                     | redis pods' priorityClassName                                                                   | `""`                                                                                                                                                                                                              |
| `redis.schedulerName`                         | Name of the k8s scheduler (other than default) for redis pods                                   | `""`                                                                                                                                                                                                              |
| `redis.lifecycleHooks`                        | for the redis container(s) to automate configuration before or after startup                    | `{}`                                                                                                                                                                                                              |
| `redis.extraEnvVars`                          | Array with extra environment variables to add to redis nodes                                    | `[]`                                                                                                                                                                                                              |
| `redis.extraEnvVarsCM`                        | Name of existing ConfigMap containing extra env vars for redis nodes                            | `lip-env`                                                                                                                                                                                                         |
| `redis.extraEnvVarsSecret`                    | Name of existing Secret containing extra env vars for redis nodes                               | `nil`                                                                                                                                                                                                             |
| `redis.extraVolumes`                          | Optionally specify extra list of additional volumes for the redis pod(s)                        | `nil`                                                                                                                                                                                                             |
| `redis.extraVolumeMounts`                     | Optionally specify extra list of additional volumeMounts for the redis container(s)             | `nil`                                                                                                                                                                                                             |
| `redis.sidecars`                              | Add additional sidecar containers to the redis pod(s)                                           | `{}`                                                                                                                                                                                                              |
| `redis.initContainers`                        | Add additional init containers to the redis pod(s)                                              | `{}`                                                                                                                                                                                                              |
| `redis.autoscaling.enabled`                   | Enable Horizontal POD autoscaling for Apache                                                    | `true`                                                                                                                                                                                                            |
| `redis.autoscaling.minReplicas`               | Minimum number of Apache replicas                                                               | `1`                                                                                                                                                                                                               |
| `redis.autoscaling.maxReplicas`               | Maximum number of Apache replicas                                                               | `5`                                                                                                                                                                                                               |
| `redis.autoscaling.targetCPU`                 | Target CPU utilization percentage                                                               | `80`                                                                                                                                                                                                              |
| `redis.autoscaling.targetMemory`              | Target Memory utilization percentage                                                            | `nil`                                                                                                                                                                                                             |


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


