pipeline {
    agent any

    environment {
        // Must match your Kubernetes deployment.yaml
        DOCKER_IMAGE   = "rehayamin9/flask-k8s-app"
        DOCKER_TAG     = "latest"

        // Must match metadata.name in deployment.yaml
        K8S_DEPLOYMENT = "flask-app-deployment"
        // You didn’t set a namespace in YAML, so it’s "default"
        K8S_NAMESPACE  = "default"
    }

    stages {
        stage('Build Docker Image') {
            steps {
                echo "Building Docker image %DOCKER_IMAGE%:%DOCKER_TAG% ..."
                bat """
                  docker version
                  docker build -t %DOCKER_IMAGE%:%DOCKER_TAG% .
                """
                // If you want to push to Docker Hub later, you can add:
                // bat "docker login -u YOUR_USER -p YOUR_PASSWORD"
                // bat "docker push %DOCKER_IMAGE%:%DOCKER_TAG%"
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                echo "Deploying to Kubernetes..."
                bat """
                  kubectl config current-context
                  kubectl apply -f kubernetes/deployment.yaml
                  kubectl apply -f kubernetes/service.yaml
                """
            }
        }

        stage('Verify Deployment') {
            steps {
                echo "Verifying deployment rollout and listing resources..."
                bat """
                  kubectl rollout status deployment/%K8S_DEPLOYMENT% --namespace=%K8S_NAMESPACE%
                  echo.
                  echo Pods:
                  kubectl get pods --namespace=%K8S_NAMESPACE%
                  echo.
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
            echo ' Deployment succeeded.'
        }
        failure {
            echo ' Pipeline failed – check the logs above.'
        }
    }
}
