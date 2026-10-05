variable "aws_region" {
  description = "AWS deployment region"
  type        = string
  default     = "af-south-1"
}

variable "project_name" {
  description = "devop-capstone"
  type        = string
  default     = "devops-capstone"
}
variable "db_password" {
  description = "Password for the PostgreSQL RDS database"
  type        = string
  sensitive   = true
}