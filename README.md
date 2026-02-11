
AWS EKS & Jenkins CI/CD Infrastructure Setup

This guide provides step-by-step instructions for provisioning an AWS EC2 management instance to orchestrate an Amazon EKS (Elastic Kubernetes Service) cluster using Jenkins.

 Prerequisites: Management Server (EC2)
Launch an Ubuntu EC2 instance (Type: t2.medium) and install the following core tools:

1. Java (JDK 11) & Jenkins
Bash

sudo apt-get update
sudo apt install openjdk-11-jre-headless -y

# Install Jenkins
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -  
sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt-get update && sudo apt-get install jenkins -y
Unlock Jenkins: Retrieve your password with sudo cat /var/lib/jenkins/secrets/initialAdminPassword.

2. Permissions & Docker
To allow Jenkins to build images, we must grant it sudo access and add it to the Docker group:

Bash

# Add Jenkins to sudoers
sudo visudo
# Add line: jenkins ALL=(ALL) NOPASSWD: ALL

# Install Docker
sudo apt install docker.io -y
sudo usermod -aG docker jenkins
3. AWS CLI & Cluster Tools
Install the tools needed to communicate with AWS and Kubernetes:

AWS CLI: sudo apt install awscli -y

Kubectl: Download and move to /usr/local/bin.

Eksctl: Download the weaveworks binary and move to /usr/local/bin.

 Cluster Provisioning
Configure your AWS credentials using aws configure, then create your cluster:

Bash

eksctl create cluster \
  --name data-test-cluster \
  --version 1.26 \
  --region us-east-1 \
  --nodegroup-name worker-nodes \
  --node-type t2.micro \
  --nodes 2
Note: Ensure your region in the command matches your AWS configuration.

Jenkins Credential Management
Before running the pipeline, store your secrets in Manage Jenkins > Credentials:

Docker Hub: Store as Secret Text (Registry credentials).

GitHub: Store as Username with password.

 Pipeline Stages
The Jenkinsfile in this project is designed to:

Checkout: Pull source code from GitHub.

Build: Package the application.

Dockerize: Build and tag the image.

Push: Upload image to Docker Hub.

Deploy: Update the EKS cluster using kubectl.

 Author
Jimmy96 T.

DevOps & Cloud Specialist

