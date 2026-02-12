pipeline {
    agent any

    environment {
        IMAGE_NAME = "jacktheskunk/jenkins-devsecops:latest"
        PATH = "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${IMAGE_NAME} ."
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('https://registry-1.docker.io', 'dockerhub-creds') {
                        sh "docker push ${IMAGE_NAME}"
                    }
                }
            }
        }

        stage('Deploy Local') {
            steps {
                sh """
                docker stop devops-app || true
                docker rm devops-app || true
                docker run -d --name devops-app -p 3000:3000 ${IMAGE_NAME}
                """
            }
        }
    }
}

