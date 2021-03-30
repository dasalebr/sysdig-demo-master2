pipeline {
  agent any
  stages {
    stage('Docker Build') {
      steps {
        sh "docker build --no-cache -t clouddemospe/podinfo:${env.BUILD_NUMBER} ."
      }
    }
    stage('Docker Push') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub', passwordVariable: 'dockerHubPassword', usernameVariable: 'dockerHubUser')]) {
          sh "docker login -u ${env.dockerHubUser} -p ${env.dockerHubPassword}"
          sh "docker push clouddemospe/podinfo:${env.BUILD_NUMBER}"
        }
      }
    }
    stage('Scan Image') {
      steps {
        sh "docker run --rm quay.io/sysdig/secure-inline-scan:2 clouddemospe/podinfo:${env.BUILD_NUMBER} -k 95bface6-74d7-418c-9154-ff64abbdd1af -s https://secure.sysdig.com"
        slackSend(message: "Imagen clouddemospe/podinfo:${env.BUILD_NUMBER} escaneada con Sysdig, mas detalle ver en el link https://secure.sysdig.com")
      }
    }
    stage('Docker Remove Image') {
      steps {
        sh "docker rmi clouddemospe/podinfo:${env.BUILD_NUMBER}"
      }
    }
    stage('Apply Kubernetes Files') {
      steps {
        sh "./assign_ver.sh $BUILD_NUMBER"
      }
  }
}
post {
    success {
      slackSend(message: "Pipeline completado.")
    }
    failure {
      slackSend(message: "Pipeline fallido. Por favor revisar los logs.")
    } 
}
}
