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
         sh "docker run --rm quay.io/sysdig/secure-inline-scan:2 andreamendoza/podinfo:${env.BUILD_NUMBER} -k 76fd9e86-db95-4b7c-9ad0-dbeadd59bfad -s https://secure.sysdig.com"
         slackSend(message: "Imagen andreamendoza/podinfo:${env.BUILD_NUMBER} escaneada con Sysdig, mas detalle ver en el link https://secure.sysdig.com")
      }
    }
    stage('Docker Remove Image') {
      steps {
        sh "docker rmi andreamendoza/podinfo:${env.BUILD_NUMBER}"
      }
    }
    stage('Apply Kubernetes Files') {
      steps {
          withKubeConfig([credentialsId: 'kubeconfig']) {
            sh 'cat deployment.yaml | sed "s/{{BUILD_NUMBER}}/$BUILD_NUMBER/g" | kubectl apply -f -'}
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
