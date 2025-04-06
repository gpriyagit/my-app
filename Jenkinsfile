pipeline {
    agent any
    environment {
        IMAGE_NAME = "my-app"
        DOCKER_HUB_USER = "swpanahd"
        EC2_HOST = "13.203.155.233"  // ← Replace with your current EC2 public IP
    }
    stages {
        stage('Clone Repo') {
            steps {
                git branch: 'main', url: 'https://github.com/dimpleswapna/my-app.git'
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${DOCKER_HUB_USER}/${IMAGE_NAME}")
                }
            }
        }
        stage('Push to Docker Hub') {
            steps {
                withDockerRegistry([credentialsId: 'dockerhub-creds', url: '']) {
                    script {
                        docker.image("${DOCKER_HUB_USER}/${IMAGE_NAME}").push('latest')
                    }
                }
            }
        }
        stage('Deploy to EC2') {
            steps {
                sshagent(['ec2-key']) {
                    sh '''
                    ssh -o StrictHostKeyChecking=no ec2-user@$EC2_HOST '
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
