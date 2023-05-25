# k8s-jenkins-aws
1.Setup an AWS EC2 Instance
The first step would be for us to set up an EC2 instance and on this instance, we will be installing -

JDK
Jenkins
eksctl
kubectl

1.1 Launch EC2 instance with instance type t2.medium
2.Install JDK on AWS EC2 Instance
   sudo apt-get update
   sudo apt install openjdk-11-jre-headless
   java -version
3.Install and Setup Jenkins
  wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -  
  sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
  sudo apt-get update
  sudo apt-get install jenkins
  sudo service jenkins status
  #If you are installing the Jenkins for the first time then you need to supply the initialAdminPassword and you can obtain it from
  sudo cat /var/lib/jenkins/secrets/initialAdminPassword
4.Setup Gradle
5.Update visudo and assign administration privileges to jenkin5. Update visudo and assign administration privileges to jenkins users user
 sudo vi /etc/sudoers
 jenkins ALL=(ALL) NOPASSWD: ALL
 sudo su - jenkins
6.Install Docker
  sudo apt install docker.io
6.1 Add jenkins user to Docker group
 sudo usermod -aG docker jenkins
7.Install and Setup AWS CLI
  sudo apt install awscli
  aws --version
7.1 Configure AWS CLI
  aws configure
  Once you execute the above command it will ask for the following information -

  AWS Access Key ID [None]:
  AWS Secret Access Key [None]:
  Default region name [None]:
  Default output format [None]:
8.Install and Setup Kubectl
  curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"    
  chmod +x ./kubectl
  sudo mv ./kubectl /usr/local/bin
9.Install and Setup eksctl
   curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
   sudo mv /tmp/eksctl /usr/local/bin 
   eksctl version
 10.Create eks cluster using eksctl
   eksctl create cluster --name data-test-cluster --version 1.26 --region us-eust-1 --nodegroup-name worker-nodes --node-type t2.micro --nodes 2
11.Add Docker and GitHub Credentials into Jenkins
11.1 Setup Docker Hub Secret Text in Jenkins
You can set the docker credentials by going into -

Goto -> Jenkins -> Manage Jenkins -> Manage Credentials -> Stored scoped to jenkins -> global -> Add Credentials

11.2 Setup GitHub Username and password into Jenkins
Now we add one more username and password for GitHub.

Goto -> Jenkins -> Manage Jenkins -> Manage Credentials -> Stored scoped to jenkins -> global -> Add Credentials
12.Add jenkins stages
Okay, now we can start writing out the Jenkins pipeline for deploying the Spring Boot Application into the Kubernetes Cluster.
