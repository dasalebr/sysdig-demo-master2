pipeline {
  agent any
  stages {
    stage('Docker Build') {
      steps {
        sh "docker build -t andreamendoza/podinfo:${env.BUILD_NUMBER} ."
      }
    }
    stage('Docker Push') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub', passwordVariable: 'dockerHubPassword', usernameVariable: 'dockerHubUser')]) {
          sh "docker login -u ${env.dockerHubUser} -p ${env.dockerHubPassword}"
          sh "docker push andreamendoza/podinfo:${env.BUILD_NUMBER}"
        }
      }
    }
    stage('Scan Image') {
      steps {
         sh "docker run --rm quay.io/sysdig/secure-inline-scan:2 andreamendoza/podinfo:${env.BUILD_NUMBER} --sysdig-token 55d7691b-d862-47a5-980d-c3f1e8c7c039 --sysdig-url https://us2.app.sysdig.com/secure"
        slackSend(message: "Imagen andreamendoza/podinfo:${env.BUILD_NUMBER} escaneada con Sysdig, mas detalle ver en el link https://us2.app.sysdig.com/secure")
      }
    }
    stage('Docker Remove Image') {
      steps {
        sh "docker rmi andreamendoza/podinfo:${env.BUILD_NUMBER}"
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
