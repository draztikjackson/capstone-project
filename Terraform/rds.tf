resource "aws_db_subnet_group" "postgres" {
  name = "capstone-project-postgres-subnet-group"

  subnet_ids = [
    aws_subnet.private_1.id,
    aws_subnet.private_2.id
  ]

  tags = {
    Name = "capstone-project-postgres-subnet-group"
  }
}

resource "aws_db_instance" "postgres" {
  identifier = "capstone-project-postgres"

  engine         = "postgres"
  engine_version = "16"

  instance_class        = "db.t3.micro"
  allocated_storage     = 20
  max_allocated_storage = 50
  storage_type          = "gp3"

  db_name  = "capstone"
  username = "capstoneadmin"
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.postgres.name
  vpc_security_group_ids = [aws_security_group.rds.id]

  publicly_accessible = false

  backup_retention_period = 1

  skip_final_snapshot = true

  deletion_protection = false

  multi_az = false

  tags = {
    Name = "capstone-project-postgres"
  }
}