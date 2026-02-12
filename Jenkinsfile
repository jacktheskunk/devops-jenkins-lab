pipeline {
    agent {
        docker {
            image 'docker:28.0.1-cli' // container con Docker CLI
            args '-v /var/run/docker.sock:/var/run/docker.sock' // monta il docker.sock
        }
    }

    environment {
        IMAGE_NAME = "jacktheskunk/jenkins-devsecops"
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
                sh 'docker build -t $IMAGE_NAME .'
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh '''
                    echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                    docker push $IMAGE_NAME
                    '''
                }
            }
        }

        stage('Deploy Local') {
            steps {
                sh '''
                docker stop devops-app || true
                docker rm devops-app || true
                docker run -d --name devops-app -p 3000:3000 $IMAGE_NAME
                '''
            }
        }
    }
}

