

## Introduction

Helm Chart for IUDX Resource Server Proxy Deployment

## Create secret files

Make a copy of sample secrets directory and add appropriate values to all files.

```console
 cp -r example-secrets/secrets .
```

```
# secrets directory after generation of secret files
secrets/
├── .rs-proxy.env
└── config.json
```

## Define Appropriate values of resources

Define Appropriate values of resources -
- CPU of all rs-proxy verticles
- RAM of all rs-proxy verticles
- ingress.hostname
- cert-manager issuer

in `resource-values.yaml` as shown in sample resource-values file for [`aws`](./example-aws-resource-values.yaml) and [`azure`](./example-azure-resource-values.yaml)

## Installing the Chart

To install the `rs-proxy`chart:

```console
 ./install.sh
```

The command deploys  rs-proxy on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

Following script will create :
1. create a namespace `rs-proxy`
2. create required configmaps
3. create corresponding K8s secrets from the secret files
4. deploy all rs-proxy verticles 

## Uninstalling the Chart

To uninstall/delete the `rs-proxy` deployment:

```console
 helm delete rs-proxy -n rs-proxy
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
| `image.registry`            | %%MAIN_CONTAINER%% image registry                             | `ghcr.io`            |
| `image.repository`          | %%MAIN_CONTAINER%% image repository                           | `datakaveri/rs-proxy-depl` |
| `image.tag`                 | %%MAIN_CONTAINER%% image tag (immutable tags are recommended) | `4.5.0-5f41e12`        |
| `image.pullPolicy`          | %%MAIN_CONTAINER%% image pull policy                          | `IfNotPresent`       |
| `image.pullSecrets`         | %%MAIN_CONTAINER%% image pull secrets                         | `nil`                |
| `image.debug`               | Enable %%MAIN_CONTAINER%% image debug mode                    | `false`              |
| `containerPorts.http`       | HTTP container port                                           | `80`                 |
| `containerPorts.https`      | HTTPS container port                                          | `443`                |
| `containerPorts.hazelcast`  | Hazelcast container port                                      | `5701`               |
| `containerPorts.prometheus` | Prometheus container port                                     | `9000`               |
| `podAnnotations`            | Annotations for pods                                          | `nil`                |


### rsProxy Parameters

| Name                                              | Description                                                                                         | Value                                                                                                                                                                                                                |
| ------------------------------------------------- | --------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `rsProxy.replicaCount`                          | Number of rsProxy replicas to deploy                                                              | `1`                                                                                                                                                                                                                  |
| `rsProxy.livenessProbe.enabled`                 | Enable livenessProbe on rsProxy containers                                                        | `true`                                                                                                                                                                                                               |
| `rsProxy.livenessProbe.initialDelaySeconds`     | Initial delay seconds for livenessProbe                                                             | `60`                                                                                                                                                                                                                 |
| `rsProxy.livenessProbe.periodSeconds`           | Period seconds for livenessProbe                                                                    | `60`                                                                                                                                                                                                                 |
| `rsProxy.livenessProbe.timeoutSeconds`          | Timeout seconds for livenessProbe                                                                   | `10`                                                                                                                                                                                                                 |
| `rsProxy.livenessProbe.failureThreshold`        | Failure threshold for livenessProbe                                                                 | `10`                                                                                                                                                                                                                 |
| `rsProxy.livenessProbe.successThreshold`        | Success threshold for livenessProbe                                                                 | `10`                                                                                                                                                                                                                 |
| `rsProxy.livenessProbe.path`                    | Path for httpGet                                                                                    | `/metrics`                                                                                                                                                                                                           |
| `rsProxy.readinessProbe.enabled`                | Enable readinessProbe on rsProxy containers                                                       | `false`                                                                                                                                                                                                              |
| `rsProxy.readinessProbe.initialDelaySeconds`    | Initial delay seconds for readinessProbe                                                            | `10`                                                                                                                                                                                                                 |
| `rsProxy.readinessProbe.periodSeconds`          | Period seconds for readinessProbe                                                                   | `10`                                                                                                                                                                                                                 |
| `rsProxy.readinessProbe.timeoutSeconds`         | Timeout seconds for readinessProbe                                                                  | `10`                                                                                                                                                                                                                 |
| `rsProxy.readinessProbe.failureThreshold`       | Failure threshold for readinessProbe                                                                | `10`                                                                                                                                                                                                                 |
| `rsProxy.readinessProbe.successThreshold`       | Success threshold for readinessProbe                                                                | `10`                                                                                                                                                                                                                 |
| `rsProxy.startupProbe.enabled`                  | Enable startupProbe on rsProxy containers                                                         | `false`                                                                                                                                                                                                              |
| `rsProxy.startupProbe.initialDelaySeconds`      | Initial delay seconds for startupProbe                                                              | `10`                                                                                                                                                                                                                 |
| `rsProxy.startupProbe.periodSeconds`            | Period seconds for startupProbe                                                                     | `10`                                                                                                                                                                                                                 |
| `rsProxy.startupProbe.timeoutSeconds`           | Timeout seconds for startupProbe                                                                    | `10`                                                                                                                                                                                                                 |
| `rsProxy.startupProbe.failureThreshold`         | Failure threshold for startupProbe                                                                  | `10`                                                                                                                                                                                                                 |
| `rsProxy.startupProbe.successThreshold`         | Success threshold for startupProbe                                                                  | `10`                                                                                                                                                                                                                 |
| `rsProxy.customLivenessProbe`                   | Custom livenessProbe that overrides the default one                                                 | `{}`                                                                                                                                                                                                                 |
| `rsProxy.customReadinessProbe`                  | Custom readinessProbe that overrides the default one                                                | `{}`                                                                                                                                                                                                                 |
| `rsProxy.customStartupProbe`                    | Custom startupProbe that overrides the default one                                                  | `{}`                                                                                                                                                                                                                 |
| `rsProxy.resources.limits`                      | The resources limits for the rsProxy containers                                                   | `nil`                                                                                                                                                                                                                |
| `rsProxy.resources.requests`                    | The requested resources for the rsProxy containers                                                | `nil`                                                                                                                                                                                                                |
| `rsProxy.podSecurityContext.enabled`            | Enabled rsProxy pods' Security Context                                                            | `false`                                                                                                                                                                                                              |
| `rsProxy.podSecurityContext.fsGroup`            | Set rsProxy pod's Security Context fsGroup                                                        | `1001`                                                                                                                                                                                                               |
| `rsProxy.containerSecurityContext.enabled`      | Enabled rsProxy containers' Security Context                                                      | `false`                                                                                                                                                                                                              |
| `rsProxy.containerSecurityContext.runAsUser`    | Set rsProxy containers' Security Context runAsUser                                                | `1001`                                                                                                                                                                                                               |
| `rsProxy.containerSecurityContext.runAsNonRoot` | Set rsProxy containers' Security Context runAsNonRoot                                             | `true`                                                                                                                                                                                                               |
| `rsProxy.existingConfigmap`                     | The name of an existing ConfigMap with your custom configuration for rsProxy                      | `nil`                                                                                                                                                                                                                |
| `rsProxy.command`                               | Override default container command (useful when using custom images)                                | `["/bin/bash"]`                                                                                                                                                                                                      |
| `rsProxy.args`                                  | Override default container args (useful when using custom images)                                   | `["-c","exec java -Xmx1024m -Dvertx.logger-delegate-factory-class-name=io.vertx.core.logging.Log4j2LogDelegateFactory -jar ./fatjar.jar  --host $$MY_POD_IP -c secrets/one-verticle-configs/config-rsProxy.json"]` |
| `rsProxy.hostAliases`                           | rsProxy pods host aliases                                                                         | `[]`                                                                                                                                                                                                                 |
| `rsProxy.podLabels`                             | Extra labels for rsProxy pods                                                                     | `{}`                                                                                                                                                                                                                 |
| `rsProxy.podAffinityPreset`                     | Pod affinity preset. Ignored if `rsProxy.affinity` is set. Allowed values: `soft` or `hard`       | `""`                                                                                                                                                                                                                 |
| `rsProxy.podAntiAffinityPreset`                 | Pod anti-affinity preset. Ignored if `rsProxy.affinity` is set. Allowed values: `soft` or `hard`  | `""`                                                                                                                                                                                                                 |
| `rsProxy.nodeAffinityPreset.type`               | Node affinity preset type. Ignored if `rsProxy.affinity` is set. Allowed values: `soft` or `hard` | `""`                                                                                                                                                                                                                 |
| `rsProxy.nodeAffinityPreset.key`                | Node label key to match. Ignored if `rsProxy.affinity` is set                                     | `""`                                                                                                                                                                                                                 |
| `rsProxy.nodeAffinityPreset.values`             | Node label values to match. Ignored if `rsProxy.affinity` is set                                  | `[]`                                                                                                                                                                                                                 |
| `rsProxy.affinity`                              | Affinity for rsProxy pods assignment                                                              | `{}`                                                                                                                                                                                                                 |
| `rsProxy.nodeSelector`                          | Node labels for rsProxy pods assignment                                                           | `nil`                                                                                                                                                                                                                |
| `rsProxy.tolerations`                           | Tolerations for rsProxy pods assignment                                                           | `[]`                                                                                                                                                                                                                 |
| `rsProxy.updateStrategy.type`                   | rsProxy statefulset strategy type                                                                 | `RollingUpdate`                                                                                                                                                                                                      |
| `rsProxy.priorityClassName`                     | rsProxy pods' priorityClassName                                                                   | `""`                                                                                                                                                                                                                 |
| `rsProxy.schedulerName`                         | Name of the k8s scheduler (other than default) for rsProxy pods                                   | `""`                                                                                                                                                                                                                 |
| `rsProxy.lifecycleHooks`                        | for the rsProxy container(s) to automate configuration before or after startup                    | `{}`                                                                                                                                                                                                                 |
| `rsProxy.extraEnvVars`                          | Array with extra environment variables to add to rsProxy nodes                                    | `[]`                                                                                                                                                                                                                 |
| `rsProxy.extraEnvVarsCM`                        | Name of existing ConfigMap containing extra env vars for rsProxy nodes                            | `rs-proxy-env`                                                                                                                                                                                                             |
| `rsProxy.extraEnvVarsSecret`                    | Name of existing Secret containing extra env vars for rsProxy nodes                               | `nil`                                                                                                                                                                                                                |
| `rsProxy.extraVolumes`                          | Optionally specify extra list of additional volumes for the rsProxy pod(s)                        | `nil`                                                                                                                                                                                                                |
| `rsProxy.extraVolumeMounts`                     | Optionally specify extra list of additional volumeMounts for the rsProxy container(s)             | `nil`                                                                                                                                                                                                                |
| `rsProxy.sidecars`                              | Add additional sidecar containers to the rsProxy pod(s)                                           | `{}`                                                                                                                                                                                                                 |
| `rsProxy.initContainers`                        | Add additional init containers to the rsProxy pod(s)                                              | `{}`                                                                                                                                                                                                                 |
| `rsProxy.autoscaling.enabled`                   | Enable Horizontal POD autoscaling for Apache                                                        | `true`                                                                                                                                                                                                               |
| `rsProxy.autoscaling.minReplicas`               | Minimum number of Apache replicas                                                                   | `1`                                                                                                                                                                                                                  |
| `rsProxy.autoscaling.maxReplicas`               | Maximum number of Apache replicas                                                                   | `7`                                                                                                                                                                                                                  |
| `rsProxy.autoscaling.targetCPU`                 | Target CPU utilization percentage                                                                   | `80`                                                                                                                                                                                                                 |
| `rsProxy.autoscaling.targetMemory`              | Target Memory utilization percentage                                                                | `nil`                                                                                                                                                                                                                                                                        |



### Traffic Exposure Parameters

| Name                               | Description                                                                                                                      | Value                    |
| ---------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `service.type`                     | rsProxy service type                                                                                                           | `ClusterIP`              |
| `service.ports`                    | rsProxy service port                                                                                                           | `80`                     |
| `service.targetPorts`              | rsProxy service TargetPorts port                                                                                               | `80`                     |
| `service.clusterIP`                | rsProxy service Cluster IP                                                                                                     | `nil`                    |
| `service.loadBalancerIP`           | rsProxy service Load Balancer IP                                                                                               | `nil`                    |
| `service.loadBalancerSourceRanges` | rsProxy service Load Balancer sources                                                                                          | `[]`                     |
| `service.externalTrafficPolicy`    | rsProxy service external traffic policy                                                                                        | `Cluster`                |
| `service.annotations`              | Additional custom annotations for rsProxy service                                                                              | `{}`                     |
| `service.extraPorts`               | Extra ports to expose in rsProxy service (normally used with the `sidecars` value)                                             | `[]`                     |
| `ingress.enabled`                  | Enable ingress record generation for rsProxy                                                                                   | `true`                   |
| `ingress.pathType`                 | Ingress path type                                                                                                                | `ImplementationSpecific` |
| `ingress.apiVersion`               | Force Ingress API version (automatically detected if not set)                                                                    | `nil`                    |
| `ingress.hostname`                 | Default host for the ingress record                                                                                              | `rs.iudx.org.in`         |
| `ingress.path`                     | Default path for the ingress record                                                                                              | `/`                      |
| `ingress.annotations`              | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}`                     |
| `ingress.serviceName`              | Backend ingress Service Name                                                                                                     | `rs-proxy`          |
| `ingress.tls.secretName`                      |    TLS secret name, if certmanager is used, no need to create that secret with tls certificates else create secret using the command ```kubectl create secret tls rs-proxy-tls-secret --key ./secrets/pki/privkey.pem --cert ./secrets/pki/fullchain.pem -n rs```                                               | `rs-proxy-tls-secret`                    |
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
 helm install rs-proxy rs-proxy \
  --set=slack.channel="#bots",slack.token="XXXX-XXXX-XXXX"
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
 helm install rs-proxy -f values.yaml rs-proxy/
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


