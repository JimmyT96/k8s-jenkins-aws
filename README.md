AWS EKS & Jenkins Hybrid CI/CD Blueprint 2026.
This repository provides a production-grade blueprint for a CI/CD pipeline orchestrated by Jenkins 2.541.1 (LTS). It is specifically architected to support Legacy Gradle 6.3 applications while deploying to modern Amazon EKS v1.35.

High-Level Architecture
The 2026 DevOps landscape requires handling "Environmental Drift." This project implements a Dual-JDK strategy:

Jenkins Controller: Runs on Java 21 for stability and security.

Build Agent: Uses Java 11 to maintain compatibility with the Gradle 6.3 build engine.

Runtime: Deploys to EKS 1.35 (Timbernetes) using cgroup v2 compliant images.

Prerequisites
1. Management Server (EC2)
OS: Ubuntu 24.04 LTS

Instance Type: t3.medium (Minimum)

Tools: Dual JDKs (11 & 21), Docker, AWS CLI, Kubectl

Bash

# Install Java 11 (Build) & Java 21 (Jenkins)
sudo apt-get update && sudo apt install openjdk-11-jdk openjdk-21-jdk -y

# Add 2026 Jenkins Signing Key
sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key

# Install Jenkins 2.541.1 (LTS)
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update && sudo apt-get install jenkins -y
2. Infrastructure Setup
EKS Cluster: Created using eksctl with version 1.35.

IAM Permissions: Jenkins requires AmazonEKSClusterPolicy and AmazonEC2ContainerRegistryFullAccess

Project Structure
File/Folder	Purpose
gradle/wrapper/	Version-locked Gradle 6.3 executable properties.
Jenkinsfile	Declarative pipeline with specialized JAVA_HOME scoping.
Dockerfile	Eclipse Temurin 11 JRE for cgroup v2 compatibility.
k8s-spring-boot.yml	Deployment manifest featuring In-Place Resizing.
docker-compose.yml	Local dev environment with resource limits synced to EKS.

CI/CD Pipeline Stages
Source: Multi-branch scan of GitHub repository.

Code Analysis: SonarQube scan (requires SONAR_TOKEN).

Legacy Build: Executes ./gradlew clean build using the JDK 11 toolchain.

Security Scan: Container vulnerability assessment.

Deploy: Rolling update to EKS v1.35 via Network Load Balancer (NLB).


Author 
JimmyT96
DevOps Engineer|Cloud Specialist
