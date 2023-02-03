pipeline {
    agent any
     parameters {
    choice(name: "TEST_CHOICE", choices: [ "development","staging", "production"], description: "Sample multi-choice parameter")
     }
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
        stage('Push Image') {
            steps {
               sh 'gcloud auth configure-docker gcr.io -q'
               sh 'sudo docker images'
               sh 'sudo docker push gcr.io/cloudside-academy/nginx-svc:$tag'
            }
        }
        stage('Image remove'){
            steps{
                sh 'sudo docker rmi gcr.io/cloudside-academy/nginx-svc:$tag'
            }
        }
        stage("Set up Kustomize"){
            steps{
                sh 'curl -sfLo kustomize https://github.com/kubernetes-sigs/kustomize/releases/download/v3.1.0/kustomize_3.1.0_linux_amd64'
                sh 'chmod u+x ./kustomize'
                sh 'kubectl get nodes'
            }
        }
        stage("Deploy Application to Development"){
             when {
                expression { return params.TEST_CHOICE == 'development' }
            }
            steps{
                sh './kustomize edit set image gcr.io/PROJECT_ID/IMAGE:TAG=gcr.io/cloudside-academy/nginx-svc:$tag'
                sh './kustomize build . | kubectl apply -f - -n development'
                sh 'kubectl get services -o wide -n development'
            }
        }
        
        //   stage('Approval') {
        //     steps {
        //         script {
        //             def deploymentDelay = input id: 'Deploy', message: 'Deploy to production?', submitter: 'rkivisto,admin', parameters: [choice(choices: ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24'], description: 'Hours to delay deployment?', name: 'deploymentDelay')]
        //             sleep time: deploymentDelay.toInteger(), unit: 'HOURS'
        //         }
        //     }
        // }
        stage("Deploy Application to Stagging"){
            when {
                expression { return params.TEST_CHOICE == 'staging' }
            }
            steps{
                sh './kustomize edit set image gcr.io/PROJECT_ID/IMAGE:TAG=gcr.io/cloudside-academy/nginx-svc:$tag'
                sh './kustomize build . | kubectl apply -f - -n staging'
                sh 'kubectl get services -o wide -n staging'
            }
        }
        stage("Deploy Application to Production"){
            when {
                expression { return params.TEST_CHOICE == 'production' }
            }
            steps{
                sh './kustomize edit set image gcr.io/PROJECT_ID/IMAGE:TAG=gcr.io/cloudside-academy/nginx-svc:$tag'
                sh './kustomize build . | kubectl apply -f - -n production'
                sh 'kubectl get services -o wide -n production'
            }
        }
