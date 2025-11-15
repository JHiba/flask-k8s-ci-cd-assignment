# Flask Kubernetes CI/CD Pipeline (flask-k8s-ci-cd-assignment)

This project demonstrates a complete CI/CD pipeline for a simple Python Flask "Hello, World!" application. The pipeline uses GitHub, GitHub Actions, Jenkins, Docker, and Kubernetes (Minikube) to automatically build, test, and deploy the application.

##  Kubernetes Features Used

This project implements several key Kubernetes features:

* **Deployments:** We use a Deployment manifest to declaratively manage the application's state.
* **Scaling:** The deployment is configured with **3 replicas** to ensure high availability and load distribution.
* **Rolling Updates:** The deployment `strategy` is set to `RollingUpdate` (with `maxSurge: 1` and `maxUnavailable: 1`). This ensures zero downtime during updates, as Kubernetes replaces old pods with new ones one by one.
* **Services:** A `NodePort` service is used to expose the application to the outside world, allowing traffic to be load-balanced across the running pods.
* **Resource Management:** The deployment sets CPU and memory `requests` (what the pod is guaranteed) and `limits` (the max it can use) to ensure stable performance and prevent one app from hogging cluster resources.

---

##  How to Run Locally (with Docker)

You can build and run this application locally using Docker.

1.  **Build the image:**
    ```bash
    # Replace 'jhiba1' with your Docker Hub ID if different
    docker build -t jhiba1/flask-k8s-app:latest .
    ```
2.  **Run the container:**
    ```bash
    docker run -d -p 5000:5000 jhiba1/flask-k8s-app:latest
    ```
3.  **View the app:**
    Open your browser and go to `http://localhost:5000`.

---

##  How to Deploy (with the Jenkins Pipeline)

This pipeline is designed to run automatically. Any push or merge to the `main` branch will trigger a new build and deployment.

1.  **Prerequisites:**
    * A running Jenkins server with the correct plugins (Pipeline, Git, Docker, Kubernetes CLI).
    * Jenkins configured with credentials for Docker Hub (ID: `dockerhub-password`) and `kubectl` access to a Minikube cluster.

2.  **Trigger the Pipeline:**
    * Make a change to the code (e.g., in `app.py`).
    * Commit and push the change to the `main` branch.
    ```bash
    git push origin main
    ```

3.  **Monitor the Deployment:**
    * The Jenkins job will start automatically.
    * The pipeline will:
        1.  Build and push the new Docker image.
        2.  Run `kubectl apply` to start a rolling update.
        3.  Run `kubectl rollout status` to verify the deployment.