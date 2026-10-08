output "ec2_instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.web.id
}

output "ec2_public_ip" {
  description = "Elastic IP address of the web server"
  value       = aws_eip.web.public_ip
}

output "ec2_public_dns" {
  description = "DNS name of the web server"
  value       = aws_instance.web.public_dns
}

output "web_server_url" {
  description = "Web server URL"
  value       = "http://${aws_eip.web.public_ip}"
}

output "ecr_repository_url" {
  description = "URL of the ECR repository"
  value       = aws_ecr_repository.web.repository_url
}