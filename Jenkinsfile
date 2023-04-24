pipeline {
  agent {
    node {
      label 'slave1'
    }
  }
  stages {
    stage('Kubescape Scan') {
      when {
        anyOf {
          changeset "Jenkinsfile"
        }
      }
      steps {
        sh 'helm template -f K8s-deployment/Charts/resource-server/values.yaml -f K8s-deployment/Charts/resource-server/example-azure-resource-values.yaml K8s-deployment/Charts/resource-server  > resource-server.yaml'
        sh 'kubescape scan resource-server.yaml --format pdf'
        publishHTML([allowMissing: false, alwaysLinkToLastBuild: true, keepAll: true, reportDir: '/var/lib/jenkins/workspace/testing-kubescape/', reportFiles: 'report.pdf', reportName: 'Kubescape Scan Report'])
      }
    }
    stage('Kubescape Scan1') {
      when {
        anyOf {
          changeset "a.txt"
        }
      }
      steps {
        sh 'helm template -f K8s-deployment/Charts/resource-server/values.yaml -f K8s-deployment/Charts/resource-server/example-azure-resource-values.yaml K8s-deployment/Charts/resource-server  > resource-server.yaml'
        sh 'kubescape scan resource-server.yaml --format pdf'
        publishHTML([allowMissing: false, alwaysLinkToLastBuild: true, keepAll: true, reportDir: '/var/lib/jenkins/workspace/testing-kubescape/', reportFiles: 'report.pdf', reportName: 'Kubescape Scan Report'])
      }
    }
  }
}
