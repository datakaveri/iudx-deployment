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
          changeset "rs.txt"
        }
      }
      steps {
                build job: 'kubescape-rs', parameters: [string(name: 'ghprbActualCommit', value: "$ghprbActualCommit"), string(name: 'ghprbPullId', value: "$ghprbPullId")]

      }
    }
    



    stage('Kubescape Scan for Auth') {
      when {
        anyOf {
          changeset "auth.txt"
        }
      }
      steps {
                build job: 'kubescape-auth', parameters: [string(name: 'ghprbActualCommit', value: "$ghprbActualCommit"), string(name: 'ghprbPullId', value: "$ghprbPullId")]

      }
    }


    stage('Kubescape Scan for CAT') {
      when {
        anyOf {
          changeset "cat.txt"
        }
      }
      steps {
                build job: 'kubescape-cat', parameters: [string(name: 'ghprbActualCommit', value: "$ghprbActualCommit"), string(name: 'ghprbPullId', value: "$ghprbPullId")]
      }
    }


    stage('Kubescape Scan for LIP') {
      when {
        anyOf {
          changeset "lip.txt"
        }
      }
      steps {
                build job: 'kubescape-lip', parameters: [string(name: 'ghprbActualCommit', value: "$ghprbActualCommit"), string(name: 'ghprbPullId', value: "$ghprbPullId")]
      }
    }


    stage('Kubescape Scan for FS') {
      when {
        anyOf {
          changeset "file.txt"
        }
      }
      steps {
                build job: 'kubescape-fs', parameters: [string(name: 'ghprbActualCommit', value: "$ghprbActualCommit"), string(name: 'ghprbPullId', value: "$ghprbPullId")]

      }
    }


    stage('Kubescape Scan for GIS') {
      when {
        anyOf {
          changeset "gis.txt"
        }
      }
      steps {
                build job: 'kubescape-gis', parameters: [string(name: 'ghprbActualCommit', value: "$ghprbActualCommit"), string(name: 'ghprbPullId', value: "$ghprbPullId")]

      }
    }


    stage('Kubescape Scan for DI') {
      when {
        anyOf {
          changeset "di.txt"
        }
      }
      steps {
                build job: 'kubescape-di', parameters: [string(name: 'ghprbActualCommit', value: "$ghprbActualCommit"), string(name: 'ghprbPullId', value: "$ghprbPullId")]

      }
    }  
  }
}






