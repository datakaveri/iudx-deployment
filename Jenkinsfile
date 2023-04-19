pipeline {
  agent {
    node {
      label 'slave1'
    }
  }

  stages {
    stage('Checking change in files'){
      when {
        anyOf {
          changeset "K8s-deployment/**"
          changeset "Jenkins"
        }
      }
      steps {
        echo "Checking for changes in files"
      }
    }
  
    stage('RS Kubescape Scan') {
      steps {
         sh 'helm template -f K8s-deployment/Charts/resource-server/values.yaml -f K8s-deployment/Charts/resource-server/example-azure-resource-values.yaml K8s-deployment/Charts/resource-server  > resource-server.yaml'
         sh 'kubescape scan resource-server.yaml --format pdf'
         publishHTML([allowMissing: false, alwaysLinkToLastBuild: true, keepAll: true, reportDir: '/var/lib/jenkins/workspace/testing-kubescape/', reportFiles: 'report.pdf', reportName: 'Kubescape Scan Report'])
      }
    }
  }
}
