pipeline {
    agent any
    environment {
        tag = sh(returnStdout: true, script: "git rev-parse --short HEAD")
    }
    stages {
        stage('Connect gke') {
            steps {
                sh 'gcloud container clusters get-credentials gke-east1 --zone us-east1-b --project cloudside-academy'
            }
        }
        stage('Build Image') {
            steps {
                git branch: 'main', url: 'https://github.com/tsa-cloudside/jenkins.git'
                sh 'sudo docker build -t gcr.io/cloudside-academy/nginx-svc:$tag .'
            }
        }
        stage('push Image') {
            steps {
               //sh 'sudo docker build -t nginx-svc .'
               sh 'gcloud auth configure-docker gcr.io -q'
               sh 'sudo docker images'
               sh 'sudo docker push gcr.io/cloudside-academy/nginx-svc:$tag'
               sh 'sudo docker rmi gcr.io/cloudside-academy/nginx-svc:$tag'
               
            }
        }
    }
}
