# terraform state file setup
# create an S3 bucket to store the state file in
resource "aws_s3_bucket" "bucket" {
    bucket = "${var.project_name}-terraform-tfstate"

    versioning {
      enabled = true
    }

    lifecycle {
      prevent_destroy = false
    }

    tags = {
      Description = "S3 Remote Terraform State Store"
    }
}

resource "aws_s3_bucket_public_access_block" "bucket" {
  bucket                  = aws_s3_bucket.bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  depends_on = [aws_s3_bucket.bucket]
}


# create a dynamodb table for locking the state file
resource "aws_dynamodb_table" "table" {
  name           = "${var.project_name}-terraform-lock"
  hash_key       = "LockID"
  billing_mode   = "PAY_PER_REQUEST"

  server_side_encryption {
    enabled = true
  }

  attribute {
    name = "LockID"
    type = "S"
  }
}
