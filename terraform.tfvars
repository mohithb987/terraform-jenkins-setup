vpc_cidr = "10.0.0.0/16"
vpc_name = "us-east-1-vpc"
public_subnet_cidr   = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidr  = ["10.0.3.0/24", "10.0.4.0/24"]
us_availability_zone = ["us-east-1a", "us-east-1c"]

ec2_ami_id         = "ami-04b70fa74e45c3917"
public_key         = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKfnARgSme6X9e8AXmGvalu91+1Cc0Zjk/arox8GJuY0 mohith@mohiths-MacBook-Air.local"