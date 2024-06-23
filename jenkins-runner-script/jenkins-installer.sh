#!/bin/bash
sudo apt-get update
yes | sudo apt install openjdk-11-jdk-headless  #req. to install Jenkins

echo "Sleeping for 30 seconds to wait until JDK installation is complete..."
sleep 30

# Jenkins Installation instructions from https://www.jenkins.io/doc/book/installing/linux/
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
yes | sudo apt-get install jenkins


sleep 30
echo "Sleeping for 30 seconds to wait until Jenkins installation is complete..."


# Terraform Installation instructions from https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo apt-get update
yes | sudo yum -y install terraform
terraform -help # to verify installation