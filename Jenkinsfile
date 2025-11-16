pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'rehayamin9/flask-k8s-app'
        DOCKER_TAG   = 'latest'
    }

    stages {
        stage('Build Docker Image') {
            steps {
                echo "Building Docker image %DOCKER_IMAGE%:%DOCKER_TAG% ..."
                bat '''
                  docker version
                  docker build -t %DOCKER_IMAGE%:%DOCKER_TAG% .
                '''
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                echo 'Deploying to Kubernetes...'
                bat '''
                  kubectl config current-context
                  kubectl apply -f kubernetes/deployment.yaml
                  kubectl apply -f kubernetes/service.yaml
                '''
            }
        }

        stage('Verify Deployment') {
            steps {
                echo 'Verifying Kubernetes deployment...'
                bat '''
                  kubectl get pods -o wide
                  kubectl get svc
                  kubectl rollout status deployment/flask-app-deployment
                '''
            }
        }
    }

    post {
        success {
            echo '✅ Pipeline succeeded!'
        }
        failure {
            echo '❌ Pipeline failed – check the logs above.'
        }
    }
}
