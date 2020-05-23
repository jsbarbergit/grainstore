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

  tags = {
    name        = "grainstore-tfstate"
    environment = "build"
  }
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
