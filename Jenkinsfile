pipeline {
    agent any

    environment {
        IMAGE_NAME = "jacktheskunk/jenkins-devsecops"
        PATH = "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" // assicura che docker sia trovato
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Building Docker image: $IMAGE_NAME"
                sh 'docker build -t $IMAGE_NAME .'
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds', // credenziali Docker Hub salvate in Jenkins
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    echo "Logging in and pushing image to Docker Hub..."
                    sh '''
                    echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                    docker push $IMAGE_NAME
                    '''
                }
            }
        }

        stage('Deploy Local') {
            steps {
                echo "Deploying container locally..."
                sh '''
                docker stop devops-app || true
                docker rm devops-app || true
                docker run -d --name devops-app -p 3000:3000 $IMAGE_NAME
                '''
            }
        }
    }

    post {
        success {
            echo "Pipeline completed successfully! Container running at http://localhost:3000"
        }
        failure {
            echo "Pipeline failed. Check console output for errors."
        }
    }
}

