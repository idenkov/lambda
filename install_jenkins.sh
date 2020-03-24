#!/bin/bash

sudo yum -y update

echo "Install Java JDK 8"
sudo yum -y install java-1.8.0-openjdk-devel

echo "Install Jenkins"
curl --silent --location http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo | sudo tee /etc/yum.repos.d/jenkins.repo
sudo rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
sudo yum -y install jenkins
sudo yum -y install git

echo "Enable Jenkins service"
sudo systemctl start jenkins
sudo systemctl enable jenkins

echo "Install Docker engine"
yum install docker -y
sudo usermod -a -G docker jenkins
sudo service docker start
sudo chkconfig docker on