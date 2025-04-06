pipeline {
    agent any

    environment {
        IMAGE_NAME = "my-app"
        DOCKER_HUB_USER = "swpanahd"
        DOCKER_IMAGE = "${DOCKER_HUB_USER}/${IMAGE_NAME}"
    }

    stages {
        stage('Clone Repo') {
            steps {
                git branch: 'main', url: 'https://github.com/dimpleswapna/my-app.git'
            }
        }

        stage('Docker Access Test') {
            steps {
                sh 'docker ps'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${DOCKER_IMAGE}")
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withDockerRegistry([credentialsId: 'dockerhub-creds', url: '']) {
                    script {
                        docker.image("${DOCKER_IMAGE}").push('latest')
                    }
                }
            }
        }

        stage('Deploy to EC2') {
            steps {
                sshagent(['ec2-key']) {
                    sh '''
                    ssh -o StrictHostKeyChecking=no ec2-user@13.201.75.241 '
                        docker pull swpanahd/my-app:latest &&
                        docker stop my-app || true &&
                        docker rm my-app || true &&
                        docker run -d -p 5000:5000 --name my-app swpanahd/my-app:latest
                    '
                    '''
                }
            }
        }
    }
}
