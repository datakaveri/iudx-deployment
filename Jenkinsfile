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
        sh 'kubescape scan -t 20 resource-server.yaml -v --format html'
        sh 'pwd'
        sh 'ls'
     }
    }
  }
}

