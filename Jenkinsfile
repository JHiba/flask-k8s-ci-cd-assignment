pipeline {
    agent any
    stages {
        stage('Build Docker Image') {
            steps {
                echo 'Building image... (To be implemented in Task 4)'
                // sh 'docker build -t your-image-name .'
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                echo 'Deploying to K8s... (To be implemented in Task 4)'
                // sh 'kubectl apply -f kubernetes/'
            }
        }
        stage('Verify Deployment') {
            steps {
                echo 'Verifying deployment... (To be implemented in Task 4)'
                // sh 'kubectl rollout status deployment/flask-app-deployment'
            }
        }
    }
}