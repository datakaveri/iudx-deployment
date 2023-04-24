pipeline {
  agent {
    node {
      label 'slave1'
    }
  }
  stages {
    stage('Kubescape Scan for RS') {
      when {
        anyOf {
          changeset "rs.txt"
        }
      }
      steps {
        sh 'helm template -f K8s-deployment/Charts/resource-server/values.yaml -f K8s-deployment/Charts/resource-server/example-azure-resource-values.yaml K8s-deployment/Charts/resource-server  > resource-server.yaml'
        sh 'kubescape scan resource-server.yaml --format pdf'
        publishHTML([allowMissing: false, alwaysLinkToLastBuild: true, keepAll: true, reportDir: '/var/lib/jenkins/workspace/testing-kubescape/', reportFiles: 'report.pdf', reportName: 'Kubescape Scan Report for RS'])
      }
    }
    stage('Kubescape Scan for Auth') {
      when {
        anyOf {
          changeset "auth.txt"
        }
      }
      steps {
        sh 'helm template -f K8s-deployment/Charts/auth-server/values.yaml -f K8s-deployment/Charts/auth-server/example-azure-resource-values.yaml K8s-deployment/Charts/auth-server  > auth-server.yaml'
        sh 'kubescape scan auth-server.yaml --format pdf'
        publishHTML([allowMissing: false, alwaysLinkToLastBuild: true, keepAll: true, reportDir: '/var/lib/jenkins/workspace/testing-kubescape/', reportFiles: 'report.pdf', reportName: 'Kubescape Scan Report for AUTH'])
      }
    }
  }
}
