terraform {
  backend "s3" {
    bucket         = "bryan-test-terraform-tfstate" # Change bucket name as needed
    key            = "helm/terraform.tfstate"
    encrypt        = "true"
    region         = "us-east-1"
    dynamodb_table = "bryan-test-terraform-lock" # Change table name as needed
  }
}

data "terraform_remote_state" "infrastructure" {
  backend   = "s3"
  workspace = terraform.workspace
  config = {
    bucket         = "bryan-test-terraform-tfstate" # Change bucket name as needed
    key            = "infrastructure/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "bryan-test-terraform-lock" # Change table name as needed
  }
}
