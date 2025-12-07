output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_eip.flask_eip.public_ip
}

output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.flask_app.id
}

output "ssh_command" {
  description = "SSH command to connect to the instance"
  value       = "ssh -i your-key.pem ubuntu@${aws_eip.flask_eip.public_ip}"
}

output "app_url" {
  description = "URL to access the application"
  value       = "http://${aws_eip.flask_eip.public_ip}:5000"
}