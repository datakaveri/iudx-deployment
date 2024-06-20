{{/*
Return the proper %%MAIN_OBJECT_BLOCK%% image name
*/}}
{{- define "geoserver.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper image name (for the init container volume-permissions image)
*/}}
{{- define "geoserver.volumePermissions.image" -}}
{{- include "common.images.image" ( dict "imageRoot" .Values.volumePermissions.image "global" .Values.global ) -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "geoserver.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.image  .Values.volumePermissions.image) "global" .Values.global) -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "geoserver.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (printf "%s-foo" (include "common.names.fullname" .)) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Return true if cert-manager required annotations for TLS signed certificates are set in the Ingress annotations
Ref: https://cert-manager.io/docs/usage/ingress/#supported-annotations
*/}}
{{- define "geoserver.ingress.certManagerRequest" -}}
{{ if or (hasKey . "cert-manager.io/cluster-issuer") (hasKey . "cert-manager.io/issuer") }}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Compile all warnings into a single message.
*/}}
{{- define "geoserver.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "geoserver.apiServer.validateValues.foo" .) -}}
{{- $messages := append $messages (include "geoserver.apiServer.validateValues.bar" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message -}}
{{- end -}}
{{- end -}}

{{- define "profanityCheck.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.profanityCheckSdk.image ) }}
{{- end -}}

{{- define "profanityCheck.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.profanityCheckSdk.image ) ) -}}
{{- end -}}