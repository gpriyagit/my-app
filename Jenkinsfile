pipeline {
    agent any
    parameters {
        string(name: 'TAG', defaultValue: 'latest', description: 'Image tag to deploy')
    }
    environment {
        IMAGE_NAME = "my-app"
        DOCKER_HUB_USER = "swpanahd"
        EC2_HOST = "13.203.155.233"  // Replace with your current EC2 public IP
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
                    docker.build("${DOCKER_HUB_USER}/${IMAGE_NAME}:${params.TAG}")
                }
            }
        }
        stage('Push to Docker Hub') {
            steps {
                withDockerRegistry([credentialsId: 'dockerhub-creds', url: '']) {
                    script {
                        docker.image("${DOCKER_HUB_USER}/${IMAGE_NAME}:${params.TAG}").push()
                    }
                }
            }
        }
        stage('Deploy to EC2') {
            steps {
                sshagent(['ssh-credential']) {
                    sh """
                    ssh -o StrictHostKeyChecking=no ubuntu@$EC2_HOST '
                        docker pull ${DOCKER_HUB_USER}/${IMAGE_NAME}:${params.TAG} &&
                        docker stop ${IMAGE_NAME} || true &&
                        docker rm ${IMAGE_NAME} || true &&
                        docker run -d -p 5000:5000 --name ${IMAGE_NAME} ${DOCKER_HUB_USER}/${IMAGE_NAME}:${params.TAG}
                    '
                    """
                }
            }
        }
    }
}
