pipeline {
  agent none

  stages {
    stage('Kubescape Scan') {
      agent {
        node {
          label 'slave1'
        }
      }
      steps {
         sh 'helm template -f K8s-deployment/Charts/resource-server/values.yaml -f K8s-deployment/Charts/resource-server/example-azure-resource-values.yaml K8s-deployment/Charts/resource-server  > resource-server.yaml'
         sh 'kubescape scan resource-server.yaml --format html'
         publishHTML([allowMissing: false, alwaysLinkToLastBuild: true, keepAll: true, reportDir: '/var/lib/jenkins/workspace/testing-kubescape/', reportFiles: 'report.html', reportName: 'Kubescape Scan Report'])

     }
    }
  }
}

