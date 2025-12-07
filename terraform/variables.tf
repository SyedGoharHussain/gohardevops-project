variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "key_pair_name" {
  description = "Name of the SSH key pair"
  type        = string
}

variable "dockerhub_username" {
  description = "Docker Hub username"
  type        = string
}

# Optional variables for Route53
# variable "domain_name" {
#   description = "Domain name for the application"
#   type        = string
#   default     = ""
# }
# 
# variable "route53_zone_id" {
#   description = "Route53 zone ID"
#   type        = string
#   default     = ""
# }