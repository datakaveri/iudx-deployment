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
        sh 'kubescape scan resource-server.yaml --format pdf --output rs-report.pdf'
      }
      post {
                always {
                        publishHTML([allowMissing: true, alwaysLinkToLastBuild: false, keepAll: true, reportDir: '/var/lib/jenkins/workspace/testing-kubescape/', reportFiles: 'rs-report.pdf', reportName: 'Kubescape Scan Report for RS'])
                }
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
        sh 'kubescape scan auth-server.yaml --format pdf --output auth-report.pdf'
      }
      post {
                always {
                    publishHTML([allowMissing: true, alwaysLinkToLastBuild: false, keepAll: true, reportDir: '/var/lib/jenkins/workspace/testing-kubescape/', reportFiles: 'auth-report.pdf', reportName: 'Kubescape Scan Report for AUTH'])
                }
            }
    }


    stage('Kubescape Scan for CAT') {
      when {
        anyOf {
          changeset "cat.txt"
        }
      }
      steps {
        sh 'helm template -f K8s-deployment/Charts/catalogue/values.yaml -f K8s-deployment/Charts/catalogue/example-azure-resource-values.yaml K8s-deployment/Charts/catalogue  > cat-server.yaml'
        sh 'kubescape scan cat-server.yaml --format pdf --output cat-report.pdf'
      }
      post {
                always {
                    publishHTML([allowMissing: true, alwaysLinkToLastBuild: false, keepAll: true, reportDir: '/var/lib/jenkins/workspace/testing-kubescape/', reportFiles: 'cat-report.pdf', reportName: 'Kubescape Scan Report for CAT'])
                }
            }
    }


    stage('Kubescape Scan for LIP') {
      when {
        anyOf {
          changeset "lip.txt"
        }
      }
      steps {
        sh 'helm template -f K8s-deployment/Charts/latest-ingestion-pipeline/values.yaml -f K8s-deployment/Charts/latest-ingestion-pipeline/example-azure-resource-values.yaml K8s-deployment/Charts/latest-ingestion-pipeline  > lip-server.yaml'
        sh 'kubescape scan lip-server.yaml --format pdf --output lip-report.pdf'
      }
      post {
                always {
                   publishHTML([allowMissing: true, alwaysLinkToLastBuild: false, keepAll: true, reportDir: '/var/lib/jenkins/workspace/testing-kubescape/', reportFiles: 'lip-report.pdf', reportName: 'Kubescape Scan Report for LIP'])
                }
            }
    }


    stage('Kubescape Scan for FS') {
      when {
        anyOf {
          changeset "file.txt"
        }
      }
      steps {
        sh 'helm template -f K8s-deployment/Charts/file-server/values.yaml -f K8s-deployment/Charts/file-server/example-azure-resource-values.yaml K8s-deployment/Charts/file-server  > file-server.yaml'
        sh 'kubescape scan file-server.yaml --format pdf --output fs-report.pdf'
      }
      post {
                always {
                    publishHTML([allowMissing: true, alwaysLinkToLastBuild: false, keepAll: true, reportDir: '/var/lib/jenkins/workspace/testing-kubescape/', reportFiles: 'fs-report.pdf', reportName: 'Kubescape Scan Report for FS'])
                }
            }
    }


    stage('Kubescape Scan for GIS') {
      when {
        anyOf {
          changeset "gis.txt"
        }
      }
      steps {
        sh 'helm template -f K8s-deployment/Charts/gis-interface/values.yaml -f K8s-deployment/Charts/gis-interface/example-azure-resource-values.yaml K8s-deployment/Charts/gis-interface  > gis-server.yaml'
        sh 'kubescape scan gis-server.yaml --format pdf --output gis-report.pdf'
      }
      post {
                always {
                    publishHTML([allowMissing: true, alwaysLinkToLastBuild: false, keepAll: true, reportDir: '/var/lib/jenkins/workspace/testing-kubescape/', reportFiles: 'gis-report.pdf', reportName: 'Kubescape Scan Report for GIS'])
                }
            }
    }


    stage('Kubescape Scan for DI') {
      when {
        anyOf {
          changeset "di.txt"
        }
      }
      steps {
        sh 'helm template -f K8s-deployment/Charts/data-ingestion/values.yaml -f K8s-deployment/Charts/data-ingestion/example-azure-resource-values.yaml K8s-deployment/Charts/data-ingestion  > di-server.yaml'
        sh 'kubescape scan di-server.yaml --format pdf --output di-report.pdf'
      }
      post {
                always {
                  publishHTML([allowMissing: true, alwaysLinkToLastBuild: false, keepAll: true, reportDir: '/var/lib/jenkins/workspace/testing-kubescape/', reportFiles: 'di-report.pdf', reportName: 'Kubescape Scan Report for DI'])
                }
            }
    }    
  }
}
