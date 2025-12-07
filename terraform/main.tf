terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
   access_key = "AKIAYKFQRE6UGZDDZ6DE"       # Not recommended for commits
  secret_key = "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"  
}

# RESOURCE DEFINITION (required for import)
resource "aws_security_group" "existing_sg" {
  name        = "launch-wizard-1"
  description = "Managed by Terraform"
  
  # Add these to match your existing SG
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# RESOURCE DEFINITION for EC2
resource "aws_instance" "portfolio" {
  # Leave empty - will be populated by import
  # Terraform will fill this from imported state
}