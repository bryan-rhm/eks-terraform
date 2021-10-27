terraform {
  backend "s3" {
    bucket          = "bryan-test-terraform-tfstate" # Change bucket name as needed
    key             = "infrastructure/terraform.tfstate"
    region          = "us-east-1"
    encrypt         = "true"
    dynamodb_table  = "bryan-test-terraform-lock" # Change table name as needed
  }
}