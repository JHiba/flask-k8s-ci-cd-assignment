pipeline {
    agent any

    environment {
        // Docker image info
        DOCKER_IMAGE = "rehayamin9/flask-k8s-app"
        DOCKER_TAG   = "latest"

        // Kubernetes settings
        K8S_DEPLOYMENT = "flask-app-deployment"
        K8S_NAMESPACE  = "default"

        // IMPORTANT: let kubectl know where the kubeconfig is
        KUBECONFIG = "C:\\kube\\config"
    }

    stages {
        stage('Build Docker Image') {
            steps {
                echo "Building Docker image %DOCKER_IMAGE%:%DOCKER_TAG% ..."
                bat """
                docker version
                docker build -t %DOCKER_IMAGE%:%DOCKER_TAG% .
                """
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                echo 'Deploying to Kubernetes...'
                bat """
                kubectl config current-context
                kubectl apply --validate=false -f kubernetes/deployment.yaml
                kubectl apply --validate=false -f kubernetes/service.yaml
                """
            }
        }

        stage('Verify Deployment') {
            steps {
                echo 'Verifying deployment rollout and services...'
                bat """
                kubectl rollout status deployment/%K8S_DEPLOYMENT% --namespace=%K8S_NAMESPACE%

                echo Pods:
                kubectl get pods --namespace=%K8S_NAMESPACE%

                echo Services:
                kubectl get services --namespace=%K8S_NAMESPACE%
                """
            }
        }
    }

    post {
        always {
            echo 'Pipeline finished (post block).'
        }
        success {
            echo 'Deployment succeeded.'
        }
        failure {
            echo '❌ Pipeline failed – check the logs above.'
        }
    }
}
