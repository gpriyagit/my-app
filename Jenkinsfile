pipeline {
    agent any
    environment {
        IMAGE_NAME = "my-app"
        DOCKER_HUB_USER = "amulyapriya"
        EC2_HOST = "13.203.155.233"
    }
    stages {
        stage('Clone Repo') {
            steps {
                git branch: 'main', url: 'https://github.com/gpriyagit/my-app.git'
            }
        }

        stage('Generate Unique Tag') {
            steps {
                script {
                    // Use timestamp as unique tag
                    TAG = sh(script: "date +%Y%m%d%H%M%S", returnStdout: true).trim()
                    echo "Generated TAG: ${TAG}"
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${DOCKER_HUB_USER}/${IMAGE_NAME}:${TAG}")
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withDockerRegistry([credentialsId: 'dockerhub-creds', url: '']) {
                    script {
                        docker.image("${DOCKER_HUB_USER}/${IMAGE_NAME}:${TAG}").push()
                    }
                }
            }
        }

        stage('Deploy to EC2') {
            steps {
                sshagent(['ssh-credential']) {
                    sh """
                    ssh -o StrictHostKeyChecking=no ubuntu@$EC2_HOST '
                        docker pull ${DOCKER_HUB_USER}/${IMAGE_NAME}:${TAG} &&
                        docker stop ${IMAGE_NAME} || true &&
                        docker rm ${IMAGE_NAME} || true &&
                        docker run -d -p 5000:5000 --name ${IMAGE_NAME} ${DOCKER_HUB_USER}/${IMAGE_NAME}:${TAG}
                    '
                    """
                }
            }
        }
    }
}
