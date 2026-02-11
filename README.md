AWS EKS & Jenkins CI/CD Infrastructure
This repository provides a production-grade blueprint for a CI/CD pipeline orchestrated by Jenkins 2.541.1 (LTS). It is architected to support Legacy Gradle 6.3 applications while deploying to modern Amazon EKS v1.35.

1. Management Server (EC2)
A dedicated Ubuntu 24.04 LTS instance (Type: t2.medium) serves as the Jenkins Controller. It is configured with a dual-JDK environment to bridge the gap between 2026 orchestration and legacy build requirements.

🧩 Jenkins 2.541.1 & Java Setup
The Jenkins 2.541.1 controller requires Java 21 to run, while the Gradle 6.3 build requires Java 11.

Bash

# 1. Install Java 11 (For Build) & Java 21 (For Jenkins 2.541.1)
sudo apt-get update
sudo apt install openjdk-11-jdk openjdk-21-jdk -y

# 2. Add Mandatory 2026 Jenkins Signing Key 
sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key

# 3. Install Jenkins 2.541.1 (LTS)
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/" | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update && sudo apt-get install jenkins -y
Containerization & Security
Bash

# Grant Jenkins permission to build Docker images
sudo apt install docker.io -y
sudo usermod -aG docker jenkins

# Enable Passwordless Sudo for Jenkins CLI tasks
sudo visudo
# Add: jenkins ALL=(ALL) NOPASSWD: ALL
2. Amazon EKS Cluster (v1.35)
Infrastructure is deployed on Kubernetes 1.35, using modern managed node groups for high availability.

Bash

eksctl create cluster \
  --name legacy-app-cluster \
  --version 1.35 \
  --region us-east-1 \
  --nodegroup-name workers-2026 \
  --node-type t3.medium \
  --nodes 2 \
  --managed
3. Legacy Compatibility (Gradle 6.3)
This project maintains a Gradle 6.3 baseline via the Gradle Wrapper to ensure build reproducibility for legacy Spring Boot microservices.

Gradle Wrapper: Defined in gradle/wrapper/gradle-wrapper.properties as version 6.3.

JDK Scoping: Jenkins is configured to use Java 11 specifically for the ./gradlew build stage to prevent version mismatch errors.

Maintenance: This setup demonstrates the ability to manage "Technical Debt" by hosting legacy build logic on modern cloud infrastructure.

 4. CI/CD Pipeline Stages
Source: Pulls from GitHub via GITHUB_CREDS.

Gradle Build: Executes ./gradlew clean build using the Java 11 environment.

Dockerize: Packages the application using the project Dockerfile.

Push: Uploads to Docker Hub via DOCKER_HUB_CREDS.

K8s Deploy: Performs a rolling update on EKS via kubectl apply.

Repository Structure
gradle/wrapper/: Contains the Gradle 6.3 executable properties.

build.gradle: Application build logic and dependencies.

Jenkinsfile: Pipeline-as-code definition for Jenkins 2.541.1.

Dockerfile: Containerization instructions for the microservice.

deployment.yml: Kubernetes manifest for the EKS 1.35 deployment.

Author
Jimmy96 T.

DevOps & Cloud Specialist
