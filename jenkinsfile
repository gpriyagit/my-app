pipeline {
    agent any

    environment {
        IMAGE_NAME = "my-app"
        AWS_REGION = "Asia Pacific (Mumbai)"
        AWS_ACCOUNT_ID = "135808931687"
        ECR_REPO = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${IMAGE_NAME}"
        EC2_USER = "ec2-user"
        EC2_HOST = "13.201.75.241"
    }

    stages {
        stage('Clone Repository') {
            steps {
                git 'https://github.com/dimpleswapna/my-app.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${IMAGE_NAME}:latest")
                }
            }
        }

        stage('Push to ECR') {
            steps {
                script {
                    sh '''
                    aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REPO
                    docker tag ${IMAGE_NAME}:latest $ECR_REPO:latest
                    docker push $ECR_REPO:latest
                    '''
                }
            }
        }

        stage('Deploy to EC2') {
            steps {
                sshagent (credentials: ['ec2-key']) {
                    sh """
                    ssh -o StrictHostKeyChecking=no ${EC2_USER}@${EC2_HOST} << EOF
                      aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REPO
                      docker pull $ECR_REPO:latest
                      docker stop ${IMAGE_NAME} || true
                      docker rm ${IMAGE_NAME} || true
                      docker run -d -p 5000:5000 --name ${IMAGE_NAME} $ECR_REPO:latest
                    EOF
                    """
                }
            }
        }
    }
}
