pipeline {
    agent any

    environment {
        // Set your Docker Hub username
        DOCKERHUB_USERNAME = "jhiba1"
        // The ID of the secret text credential Reha will create in Jenkins
        DOCKERHUB_CREDENTIAL_ID = "dockerhub-password"
    }

    stages {
        // Stage 1: Build the image and push it to Docker Hub
        stage('Build Docker Image') {
            steps {
                echo 'Building and Pushing Docker Image...'
                
                // Build the image with your Docker ID
                sh "docker build -t ${DOCKERHUB_USERNAME}/flask-k8s-app:latest ."
                
                // Log in to Docker Hub using the secure Jenkins credential
                // We wrap this in 'withCredentials'
                withCredentials([string(credentialsId: DOCKERHUB_CREDENTIAL_ID, variable: 'DOCKERHUB_PASSWORD')]) {
                    sh "docker login -u ${DOCKERHUB_USERNAME} -p ${DOCKERHUB_PASSWORD}"
                }
                
                // Push the image to Docker Hub
                sh "docker push ${DOCKERHUB_USERNAME}/flask-k8s-app:latest"
            }
        }

        // Stage 2: Deploy the new image to Kubernetes
        stage('Deploy to Kubernetes') {
            steps {
                echo 'Deploying to Kubernetes...'
                // Apply the configurations. K8s will see the new image tag and start a rollout.
                sh 'kubectl apply -f kubernetes/'
            }
        }

        // Stage 3: Verify the deployment was successful
        stage('Verify Deployment') {
            steps {
                echo 'Verifying deployment...'
                // Wait for the rollout to complete
                sh 'kubectl rollout status deployment/flask-app-deployment'
                
                // Show the running pods and services
                sh 'kubectl get pods,services'
            }
        }
    }
    post {
        // This 'always' block runs no matter what, to clean up
        always {
            echo 'Logging out of Docker Hub...'
            // Log out of Docker Hub to be safe
            sh 'docker logout'
        }
    }
}