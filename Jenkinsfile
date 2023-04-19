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
        sh 'kubescape scan -t 20 resource-server.yaml -v --format html'
        sh 'helm template -f values.yaml -f example-azure-resource-values.yaml ../resource-server  > resource-server.yaml'
        sh 'pwd'
        sh 'ls'
     }
    }
  }
}

