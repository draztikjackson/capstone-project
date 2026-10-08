resource "aws_ecr_repository" "web" {
  name                 = "capstone-web"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "capstone-web"
  }
}