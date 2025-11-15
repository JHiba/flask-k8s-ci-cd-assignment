pipeline {
    agent any

    environment {
        // Local image name that your Kubernetes deployment uses
        DOCKER_IMAGE   = "flask-k8s-app"
        DOCKER_TAG     = "latest"

        // Adjust these to match your deployment YAML
        K8S_DEPLOYMENT = "flask-app-deployment"
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
                // If you need to push to Docker Hub, add here:
                // bat "docker login -u YOUR_USER -p YOUR_PASSWORD"
                // bat "docker tag %DOCKER_IMAGE%:%DOCKER_TAG% YOUR_USER/%DOCKER_IMAGE%:%DOCKER_TAG%"
                // bat "docker push YOUR_USER/%DOCKER_IMAGE%:%DOCKER_TAG%"
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                echo "Deploying manifests to Kubernetes..."
                bat """
                  kubectl config current-context
                  kubectl apply -f kubernetes/deployment.yaml
                  kubectl apply -f kubernetes/service.yaml
                """
            }
        }

        stage('Verify Deployment') {
            steps {
                echo "Verifying rollout and listing resources..."
                bat """
                  kubectl rollout status deployment/%K8S_DEPLOYMENT% --namespace=%K8S_NAMESPACE% --timeout=120s
                  kubectl get pods,services --namespace=%K8S_NAMESPACE%
                """
            }
        }
    }

    post {
        always {
            echo "Post-build: logging out of Docker Hub (if logged in)..."
            bat """
              docker logout || echo "Docker logout failed or not logged in – continuing..."
            """
        }
        success {
            echo "CI/CD pipeline completed successfully 🎉"
        }
        failure {
            echo "CI/CD pipeline FAILED – check the console output ❌"
        }
    }
}
