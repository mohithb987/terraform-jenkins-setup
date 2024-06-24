#!/bin/bash
sudo apt-get update
yes | sudo apt install openjdk-11-jdk-headless  #req. to install Jenkins

echo "Sleeping for 30 seconds to wait until JDK installation is complete..."
sleep 30

# Jenkins Installation instructions from https://www.jenkins.io/doc/book/installing/linux/
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
sleep 20
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sleep 20
sudo apt-get update
yes | sudo apt-get install jenkins

echo "Sleeping for 30 seconds to wait until Jenkins is enabled..."
sleep 60

sudo systemctl enable jenkins
sleep 10
sudo systemctl start jenkins
sleep 10
sudo systemctl status jenkins


# Terraform Installation instructions from https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli
wget https://releases.hashicorp.com/terraform/1.6.5/terraform_1.6.5_linux_386.zip
yes | sudo apt-get install unzip
unzip 'terraform*.zip'
sudo mv terraform /usr/local/bin/