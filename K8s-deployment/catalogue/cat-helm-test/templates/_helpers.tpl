{{/*
Expand the name of the chart.
*/}}
{{- define "cat-helm-test.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "cat-helm-test.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "cat-helm-test.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "cat-helm-test.labels" -}}
helm.sh/chart: {{ include "cat-helm-test.chart" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "cat-helm-test.selectorLabels" -}}
app.kubernetes.io/name: {{ include "cat-helm-test.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- range $str := .Values.service.selector }}
{{- toYaml . }}
{{- end }}
{{- end }}

{{- define "cat-helm-test.service.selectorLabels" -}}
{{- range $str := .Values.service.selector }}
{{- toYaml . }}
{{- end }}
{{- end }}

{{- define "cat-helm-test.apiserver.selectorLabels" -}}
{{- range $str := .Values.apiserver.labels }}
{{- toYaml . }}
{{- end }}
{{- end }}

{{- define "cat-helm-test.auditing.selectorLabels" -}}
{{- range $str := .Values.auditing.labels }}
{{- toYaml . }}
{{- end }}
{{- end }}

{{- define "cat-helm-test.authenticator.selectorLabels" -}}
{{- range $str := .Values.auditing.labels }}
{{- toYaml . }}
{{- end }}
{{- end }}




{{- define "cat-helm-test.database.selectorLabels" -}}
{{- range $str := .Values.auditing.labels }}
{{- toYaml . }}
{{- end }}
{{- end }}

{{- define "cat-helm-test.validator.selectorLabels" -}}
{{- range $str := .Values.auditing.labels }}
{{- toYaml . }}
{{- end }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "cat-helm-test.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "cat-helm-test.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "cat-helm-test.annotation" -}}
prometheus.io/port: {{ .Values.containerPorts.prometheus.port | quote }}
prometheus.io/scrape: {{ .Values.containerPorts.prometheus.scrape | quote }}
{{- end }}

{{- define "cat-helm-test.livenessProbe.httpGet" -}}
path: {{ .Values.livenessProbe.httpGet.path}} 
port: {{ .Values.livenessProbe.httpGet.port}} 
{{- end }}


{{- define "cat-helm-test.env.myPodIp" -}}
valueFrom:
  fieldRef:
    fieldPath: {{ .Values.env.fieldPath }}
{{- end }}

{{- define "cat-helm-test.nodeselector" -}}
{{- range $str := .Values.apiserver.labels }}
{{- toYaml . }}
{{- end }}
{{- end }}

{{- define "cat-helm-test.ingressRateLimit.annotation" -}}
nginx.ingress.kubernetes.io/global-rate-limit: "1000"
nginx.ingress.kubernetes.io/global-rate-limit-key: $server_name
nginx.ingress.kubernetes.io/global-rate-limit-window: 1s
{{- end }}