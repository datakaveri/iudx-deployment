[![Kubescape Status](https://img.shields.io/jenkins/build?jobUrl=https%3A%2F%2Fjenkins.iudx.io%2Fjob%2Fkubescape-auth%2F&label=Kubescape)](https://jenkins.iudx.io/job/kubescape-auth/lastBuild/Kubescape_20Scan_20Report_20for_20AAA/)

## Introduction

Helm Chart for IUDX auth-server Deployment

## Create secret files

Make a copy of sample secrets directory and add appropriate values to all files.

```console
 cp -r example-secrets/secrets .
```

```
# secrets directory after generation of secret files
secrets/
├── .aaa.env
├── config.json
└── keystore.jks
```

## Define Appropriate values of resources

Define Appropriate values of resources -
- CPU of all aaa-server verticles
- RAM of all aaa-server verticles
- ingress.hostname
- cert-manager issuer

in `resource-values.yaml` as shown in sample resource-values file for [`aws`](./example-aws-resource-values.yaml) and [`azure`](./example-azure-resource-values.yaml)

## Installing the Chart

To install the `auth-server`chart:

```console
 ./install.sh
```

The command deploys auth-server on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

Following script will create :
1. create a namespace `aaa`
2. create required configmaps
3. create corresponding K8s secrets from the secret files
4. deploy all aaa-server verticles 

### To create ingress redirect to cos url:
```console
kubectl apply -f ../../misc/old-aaa-ingress.yaml -n aaa
```

## Uninstalling the Chart

To uninstall/delete the `auth-server` deployment:

```console
 helm delete auth-server
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
| `nameSpace`              | Namespace to deploy the controller                                                      | `aaa`           |
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
| `image.repository`          | image repository                           | `datakaveri/aaa-depl` |
| `image.tag`                 | image tag (immutable tags are recommended) | `3.0-40b9130`         |
| `image.pullPolicy`          | image pull policy                          | `IfNotPresent`        |
| `image.pullSecrets`         | image pull secrets                         | `{}`                  |
| `image.debug`               | Enable image debug mode                    | `false`               |
| `containerPorts.http`       | HTTP container port                        | `8443`                |
| `containerPorts.https`      | HTTPS container port                       | `443`                 |
| `containerPorts.hazelcast`  | Hazelcast container port                   | `5701`                |
| `containerPorts.prometheus` | Prometheus container port                  | `9000`                |
| `podAnnotations`            | Annotations for pods                       | `nil`                 |


### ApiServer Parameters

| Name                                              | Description                                                                                         | Value                                                                                                                                                                                                                                        |
| ------------------------------------------------- | --------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `apiServer.replicaCount`                          | Number of ApiServer replicas to deploy                                                              | `1`                                                                                                                                                                                                                                          |
| `apiServer.livenessProbe.enabled`                 | Enable livenessProbe on ApiServer containers                                                        | `true`                                                                                                                                                                                                                                       |
| `apiServer.livenessProbe.initialDelaySeconds`     | Initial delay seconds for livenessProbe                                                             | `60`                                                                                                                                                                                                                                         |
| `apiServer.livenessProbe.periodSeconds`           | Period seconds for livenessProbe                                                                    | `60`                                                                                                                                                                                                                                         |
| `apiServer.livenessProbe.timeoutSeconds`          | Timeout seconds for livenessProbe                                                                   | `10`                                                                                                                                                                                                                                         |
| `apiServer.livenessProbe.failureThreshold`        | Failure threshold for livenessProbe                                                                 | `10`                                                                                                                                                                                                                                         |
| `apiServer.livenessProbe.successThreshold`        | Success threshold for livenessProbe                                                                 | `10`                                                                                                                                                                                                                                         |
| `apiServer.livenessProbe.path`                    | Path for httpGet                                                                                    | `/metrics`                                                                                                                                                                                                                                   |
| `apiServer.readinessProbe.enabled`                | Enable readinessProbe on ApiServer containers                                                       | `false`                                                                                                                                                                                                                                      |
| `apiServer.readinessProbe.initialDelaySeconds`    | Initial delay seconds for readinessProbe                                                            | `10`                                                                                                                                                                                                                                         |
| `apiServer.readinessProbe.periodSeconds`          | Period seconds for readinessProbe                                                                   | `10`                                                                                                                                                                                                                                         |
| `apiServer.readinessProbe.timeoutSeconds`         | Timeout seconds for readinessProbe                                                                  | `10`                                                                                                                                                                                                                                         |
| `apiServer.readinessProbe.failureThreshold`       | Failure threshold for readinessProbe                                                                | `10`                                                                                                                                                                                                                                         |
| `apiServer.readinessProbe.successThreshold`       | Success threshold for readinessProbe                                                                | `10`                                                                                                                                                                                                                                         |
| `apiServer.startupProbe.enabled`                  | Enable startupProbe on ApiServer containers                                                         | `false`                                                                                                                                                                                                                                      |
| `apiServer.startupProbe.initialDelaySeconds`      | Initial delay seconds for startupProbe                                                              | `10`                                                                                                                                                                                                                                         |
| `apiServer.startupProbe.periodSeconds`            | Period seconds for startupProbe                                                                     | `10`                                                                                                                                                                                                                                         |
| `apiServer.startupProbe.timeoutSeconds`           | Timeout seconds for startupProbe                                                                    | `10`                                                                                                                                                                                                                                         |
| `apiServer.startupProbe.failureThreshold`         | Failure threshold for startupProbe                                                                  | `10`                                                                                                                                                                                                                                         |
| `apiServer.startupProbe.successThreshold`         | Success threshold for startupProbe                                                                  | `10`                                                                                                                                                                                                                                         |
| `apiServer.customLivenessProbe`                   | Custom livenessProbe that overrides the default one                                                 | `{}`                                                                                                                                                                                                                                         |
| `apiServer.customReadinessProbe`                  | Custom readinessProbe that overrides the default one                                                | `{}`                                                                                                                                                                                                                                         |
| `apiServer.customStartupProbe`                    | Custom startupProbe that overrides the default one                                                  | `{}`                                                                                                                                                                                                                                         |
| `apiServer.resources.limits`                      | The resources limits for the ApiServer containers                                                   | `{}`                                                                                                                                                                                                                                         |
| `apiServer.resources.requests`                    | The requested resources for the ApiServer containers                                                | `{}`                                                                                                                                                                                                                                         |
| `apiServer.podSecurityContext.enabled`            | Enabled ApiServer pods' Security Context                                                            | `false`                                                                                                                                                                                                                                      |
| `apiServer.podSecurityContext.fsGroup`            | Set ApiServer pod's Security Context fsGroup                                                        | `1001`                                                                                                                                                                                                                                       |
| `apiServer.containerSecurityContext.enabled`      | Enabled ApiServer containers' Security Context                                                      | `false`                                                                                                                                                                                                                                      |
| `apiServer.containerSecurityContext.runAsUser`    | Set ApiServer containers' Security Context runAsUser                                                | `1001`                                                                                                                                                                                                                                       |
| `apiServer.containerSecurityContext.runAsNonRoot` | Set ApiServer containers' Security Context runAsNonRoot                                             | `true`                                                                                                                                                                                                                                       |
| `apiServer.existingConfigmap`                     | The name of an existing ConfigMap with your custom configuration for ApiServer                      | `nil`                                                                                                                                                                                                                                        |
| `apiServer.command`                               | Override default container command (useful when using custom images)                                | `["/bin/bash"]`                                                                                                                                                                                                                              |
| `apiServer.args`                                  | Override default container args (useful when using custom images)                                   | `["-c","exec java -Xmx1024m -Dvertx.logger-delegate-factory-class-name=io.vertx.core.logging.Log4j2LogDelegateFactory -jar ./fatjar.jar  --host $$MY_POD_IP -c secrets/configs/config.json -m iudx.aaa.server.apiserver.ApiServerVerticle"]` |
| `apiServer.hostAliases`                           | ApiServer pods host aliases                                                                         | `[]`                                                                                                                                                                                                                                         |
| `apiServer.podLabels`                             | Extra labels for ApiServer pods                                                                     | `{}`                                                                                                                                                                                                                                         |
| `apiServer.podAffinityPreset`                     | Pod affinity preset. Ignored if `apiServer.affinity` is set. Allowed values: `soft` or `hard`       | `""`                                                                                                                                                                                                                                         |
| `apiServer.podAntiAffinityPreset`                 | Pod anti-affinity preset. Ignored if `apiServer.affinity` is set. Allowed values: `soft` or `hard`  | `""`                                                                                                                                                                                                                                         |
| `apiServer.nodeAffinityPreset.type`               | Node affinity preset type. Ignored if `apiServer.affinity` is set. Allowed values: `soft` or `hard` | `""`                                                                                                                                                                                                                                         |
| `apiServer.nodeAffinityPreset.key`                | Node label key to match. Ignored if `apiServer.affinity` is set                                     | `""`                                                                                                                                                                                                                                         |
| `apiServer.nodeAffinityPreset.values`             | Node label values to match. Ignored if `apiServer.affinity` is set                                  | `[]`                                                                                                                                                                                                                                         |
| `apiServer.affinity`                              | Affinity for ApiServer pods assignment                                                              | `{}`                                                                                                                                                                                                                                         |
| `apiServer.nodeSelector`                          | Node labels for ApiServer pods assignment                                                           | `nil`                                                                                                                                                                                                                                        |
| `apiServer.tolerations`                           | Tolerations for ApiServer pods assignment                                                           | `[]`                                                                                                                                                                                                                                         |
| `apiServer.updateStrategy.type`                   | ApiServer statefulset strategy type                                                                 | `RollingUpdate`                                                                                                                                                                                                                              |
| `apiServer.priorityClassName`                     | ApiServer pods' priorityClassName                                                                   | `""`                                                                                                                                                                                                                                         |
| `apiServer.schedulerName`                         | Name of the k8s scheduler (other than default) for ApiServer pods                                   | `""`                                                                                                                                                                                                                                         |
| `apiServer.lifecycleHooks`                        | for the ApiServer container(s) to automate configuration before or after startup                    | `{}`                                                                                                                                                                                                                                         |
| `apiServer.extraEnvVars`                          | Array with extra environment variables to add to ApiServer nodes                                    | `[]`                                                                                                                                                                                                                                         |
| `apiServer.extraEnvVarsCM`                        | Name of existing ConfigMap containing extra env vars for ApiServer nodes                            | `aaa-env`                                                                                                                                                                                                                                    |
| `apiServer.extraEnvVarsSecret`                    | Name of existing Secret containing extra env vars for ApiServer nodes                               | `nil`                                                                                                                                                                                                                                        |
| `apiServer.extraVolumes`                          | Optionally specify extra list of additional volumes for the ApiServer pod(s)                        | `nil`                                                                                                                                                                                                                                        |
| `apiServer.extraVolumeMounts`                     | Optionally specify extra list of additional volumeMounts for the ApiServer container(s)             | `nil`                                                                                                                                                                                                                                        |
| `apiServer.sidecars`                              | Add additional sidecar containers to the ApiServer pod(s)                                           | `{}`                                                                                                                                                                                                                                         |
| `apiServer.initContainers`                        | Add additional init containers to the ApiServer pod(s)                                              | `{}`                                                                                                                                                                                                                                         |
| `apiServer.autoscaling.enabled`                   | Enable Horizontal POD autoscaling for Apache                                                        | `true`                                                                                                                                                                                                                                       |
| `apiServer.autoscaling.minReplicas`               | Minimum number of Apache replicas                                                                   | `1`                                                                                                                                                                                                                                          |
| `apiServer.autoscaling.maxReplicas`               | Maximum number of Apache replicas                                                                   | `5`                                                                                                                                                                                                                                          |
| `apiServer.autoscaling.targetCPU`                 | Target CPU utilization percentage                                                                   | `80`                                                                                                                                                                                                                                         |
| `apiServer.autoscaling.targetMemory`              | Target Memory utilization percentage                                                                | `nil`                                                                                                                                                                                                                                        |




### Traffic Exposure Parameters

| Name                               | Description                                                                                                                      | Value                    |
| ---------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `service.type`                     | ApiServers ervice type                                                                                                           | `ClusterIP`              |
| `service.ports`                    | ApiServer service port                                                                                                           | `80`                     |
| `service.targetPorts`              | ApiServer service TargetPorts port                                                                                               | `8443`                   |
| `service.clusterIP`                | ApiServer service Cluster IP                                                                                                     | `nil`                    |
| `service.loadBalancerIP`           | ApiServer service Load Balancer IP                                                                                               | `nil`                    |
| `service.loadBalancerSourceRanges` | service Load Balancer sources                                                                                                    | `[]`                     |
| `service.externalTrafficPolicy`    | service external traffic policy                                                                                                  | `Cluster`                |
| `service.annotations`              | Additional custom annotations for service                                                                                        | `{}`                     |
| `service.extraPorts`               | Extra ports to expose in service (normally used with the `sidecars` value)                                                       | `[]`                     |
| `ingress.enabled`                  | Enable ingress record generation for %%MAIN_CONTAINER_NAME%%                                                                     | `true`                   |
| `ingress.pathType`                 | Ingress path type                                                                                                                | `ImplementationSpecific` |
| `ingress.apiVersion`               | Force Ingress API version (automatically detected if not set)                                                                    | `nil`                    |
| `ingress.hostname`                 | Default host for the ingress record                                                                                              | `auth.iudx.org.in`       |
| `ingress.path`                     | Default path for the ingress record                                                                                              | `/`                      |
| `ingress.annotations`              | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}`                     |
| `ingress.serviceName`              | Backend ingress Service Name                                                                                                     | `aaa-api-server`         |
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

| Name                    | Description                                          | Value   |
| ----------------------- | ---------------------------------------------------- | ------- |
| `rbac.create`           | Specifies whether RBAC resources should be created   | `false` |
| `serviceAccount.create` | Specifies whether a ServiceAccount should be created | `false` |
| `serviceAccount.name`   | The name of the ServiceAccount to use.               | `""`    |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
 helm install auth-server auth-server \
  --set=slack.channel="#bots",slack.token="XXXX-XXXX-XXXX"
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
 helm install auth-server -f values.yaml auth-server/
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


