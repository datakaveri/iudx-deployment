pipeline {
  agent {
    node {
      label 'built-in'
    }
  }


  stages {
    stage('Kubescape Scan for RS') {
      when {
        anyOf {
          changeset "K8s-deployment/Charts/resource-server/templates/*"
          changeset "K8s-deployment/Charts/resource-server/values.yaml"
        }
      }
      steps {
                build job: 'kubescape-rs', parameters: [string(name: 'ghprbActualCommit', value: "$ghprbActualCommit"), string(name: 'ghprbPullId', value: "$ghprbPullId")]

      }
    }
    



    stage('Kubescape Scan for Auth') {
      when {
        anyOf {
          changeset "K8s-deployment/Charts/auth-server/templates/*"
          changeset "K8s-deployment/Charts/auth-server/values.yaml"
        }
      }
      steps {
                build job: 'kubescape-auth', parameters: [string(name: 'ghprbActualCommit', value: "$ghprbActualCommit"), string(name: 'ghprbPullId', value: "$ghprbPullId")]

      }
    }


    stage('Kubescape Scan for CAT') {
      when {
        anyOf {
          changeset "K8s-deployment/Charts/catalogue/templates/*"
          changeset "K8s-deployment/Charts/catalogue/values.yaml"        }
      }
      steps {
                build job: 'kubescape-cat', parameters: [string(name: 'ghprbActualCommit', value: "$ghprbActualCommit"), string(name: 'ghprbPullId', value: "$ghprbPullId")]
      }
    }


    stage('Kubescape Scan for LIP') {
      when {
        anyOf {
          changeset "K8s-deployment/Charts/latest-ingestion-pipeline/templates/*"
          changeset "K8s-deployment/Charts/latest-ingestion-pipeline/values.yaml"        }
      }
      steps {
                build job: 'kubescape-lip', parameters: [string(name: 'ghprbActualCommit', value: "$ghprbActualCommit"), string(name: 'ghprbPullId', value: "$ghprbPullId")]
      }
    }


    stage('Kubescape Scan for FS') {
      when {
        anyOf {
          changeset "K8s-deployment/Charts/file-server/templates/*"
          changeset "K8s-deployment/Charts/file-server/values.yaml"        }
      }
      steps {
                build job: 'kubescape-fs', parameters: [string(name: 'ghprbActualCommit', value: "$ghprbActualCommit"), string(name: 'ghprbPullId', value: "$ghprbPullId")]

      }
    }


    stage('Kubescape Scan for GIS') {
      when {
        anyOf {
          changeset "K8s-deployment/Charts/gis-interface/templates/*"
          changeset "K8s-deployment/Charts/gis-interface/values.yaml"        }
      }
      steps {
                build job: 'kubescape-gis', parameters: [string(name: 'ghprbActualCommit', value: "$ghprbActualCommit"), string(name: 'ghprbPullId', value: "$ghprbPullId")]

      }
    }


    stage('Kubescape Scan for DI') {
      when {
        anyOf {
          changeset "K8s-deployment/Charts/data-ingestion/templates/*"
          changeset "K8s-deployment/Charts/data-ingestion/values.yaml"        }
      }
      steps {
                build job: 'kubescape-di', parameters: [string(name: 'ghprbActualCommit', value: "$ghprbActualCommit"), string(name: 'ghprbPullId', value: "$ghprbPullId")]

      }
    }

    stage('Kubescape Scan for Auditing Server') {
      when {
        anyOf {
          changeset "K8s-deployment/Charts/auditing-server/templates/*"
          changeset "K8s-deployment/Charts/auditing-server/values.yaml"        }
      }
      steps {
                build job: 'kubescape-auditing', parameters: [string(name: 'ghprbActualCommit', value: "$ghprbActualCommit"), string(name: 'ghprbPullId', value: "$ghprbPullId")]

      }
    }   
  }
}






