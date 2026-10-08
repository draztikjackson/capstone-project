# ============================================================
# Stage 15 - EC2 Web Server
# ============================================================

# Get the latest Amazon Linux 2023 AMI
data "aws_ssm_parameter" "al2023_ami" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

# IAM role for the EC2 instance
resource "aws_iam_role" "ec2_role" {
  name = "capstone-project-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ec2.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "capstone-project-ec2-role"
  }
}

# Allow the EC2 instance to be managed through AWS Systems Manager
resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Allow EC2 to pull Docker images from Amazon ECR
resource "aws_iam_role_policy_attachment" "ecr_read" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

# Instance profile connects the IAM role to EC2
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "capstone-project-ec2-profile"
  role = aws_iam_role.ec2_role.name
}

# EC2 web server
resource "aws_instance" "web" {
  ami = data.aws_ssm_parameter.al2023_ami.value

  instance_type = "t3.micro"

  subnet_id = aws_subnet.public_1.id

  vpc_security_group_ids = [
    aws_security_group.ec2.id
  ]

  associate_public_ip_address = true

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  user_data = <<-EOF
              #!/bin/bash

              dnf update -y

              dnf install -y docker

              systemctl enable docker
              systemctl start docker

              usermod -aG docker ec2-user

              echo "Docker installation completed" > /home/ec2-user/docker-status.txt
              EOF

  tags = {
    Name = "capstone-project-web-server"
  }
}
# Elastic IP for the web server
resource "aws_eip" "web" {
  domain = "vpc"

  tags = {
    Name = "capstone-project-web-eip"
  }
}

# Associate Elastic IP with EC2
resource "aws_eip_association" "web" {
  instance_id   = aws_instance.web.id
  allocation_id = aws_eip.web.id
}