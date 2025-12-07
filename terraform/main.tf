terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  
  backend "s3" {
    # Configure your S3 backend for state storage
    # bucket = "your-terraform-state-bucket"
    # key    = "gohardevops/terraform.tfstate"
    # region = "us-east-1"
  }
}

provider "aws" {
  region = var.aws_region
}

# Security Group for EC2
resource "aws_security_group" "flask_sg" {
  name        = "flask-app-sg"
  description = "Security group for Flask application"
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH access"
  }
  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP access"
  }
  
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTPS access"
  }
  
  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Flapp app port"
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "flask-app-sg"
  }
}

# EC2 Instance
resource "aws_instance" "flask_app" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = var.key_pair_name
  vpc_security_group_ids = [aws_security_group.flask_sg.id]
  
  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }
  
  user_data = <<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y docker.io docker-compose
              systemctl start docker
              systemctl enable docker
              usermod -aG docker ubuntu
              EOF
  
  tags = {
    Name = "gohardevops-flask-app"
    Project = "GoHardDevOps"
  }
  
  lifecycle {
    create_before_destroy = true
  }
}

# Elastic IP
resource "aws_eip" "flask_eip" {
  instance = aws_instance.flask_app.id
  domain   = "vpc"
  
  tags = {
    Name = "flask-app-eip"
  }
}

# Route53 Record (optional)
# resource "aws_route53_record" "app" {
#   zone_id = var.route53_zone_id
#   name    = var.domain_name
#   type    = "A"
#   ttl     = 300
#   records = [aws_eip.flask_eip.public_ip]
# }

data "aws_ami" "ubuntu" {
  most_recent = true
  
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  
  owners = ["099720109477"] # Canonical
}