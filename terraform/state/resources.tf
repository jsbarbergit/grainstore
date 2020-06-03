# TF State Management Resources
resource "aws_s3_bucket" "state_s3_bucket" {
  bucket = "grainstore-tfstate"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }

  acl = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    name        = "grainstore-tfstate"
    environment = "build"
  }

  # Ignore logging warning from tfsec scan for this bucket
  #tfsec:ignore:AWS002
}

resource "aws_dynamodb_table" "product_dynamodb_table" {
  name           = "grainstore-tflock"
  hash_key       = "LockID"
  read_capacity  = 1
  write_capacity = 1

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    name        = "grainstore-tflock"
    environment = "build"
  }
}
