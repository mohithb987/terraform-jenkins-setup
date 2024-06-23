variable "ami_id" {}
variable "max_price" {}
variable "instance_type" {}
variable "tag_name" {}
variable "public_key" {}
variable "subnet_id" {}
variable "sg_for_jenkins" {}
variable "associate_public_ip_address" {}
variable "user_data_install_jenkins" {}

resource "aws_instance" "jenkins_ec2_instance" {
  ami           = var.ami_id
  instance_market_options {
    market_type = "spot"
    spot_options {
      max_price = var.max_price
      spot_instance_type = "persistent"
      instance_interruption_behavior = "stop" # set to 'hibernate' if quick boot up is required
    }
  }
  instance_type = var.instance_type
  tags = {
    Name = var.tag_name
  }
  key_name                    = "aws_ec2_terraform"
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.sg_for_jenkins
  associate_public_ip_address = var.associate_public_ip_address

  user_data = var.user_data_install_jenkins

  metadata_options {
    http_endpoint = "enabled"  # Enable the IMDSv2 endpoint
    http_tokens   = "required" # Require the use of IMDSv2 tokens
  }
}

resource "aws_key_pair" "jenkins_ec2_instance_public_key" {
  key_name   = "aws_ec2_terraform"
  public_key = var.public_key
}