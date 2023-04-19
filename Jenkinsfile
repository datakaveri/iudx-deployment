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
        sh 'pwd'
        sh 'ls'
     }
    }
  }
}

