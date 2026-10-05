terraform {
  backend "s3" {
    bucket       = "capstone-project-tfstate-317345516803"
    key          = "terraform/terraform.tfstate"
    region       = "af-south-1"
    encrypt      = true
    use_lockfile = true
  }
}