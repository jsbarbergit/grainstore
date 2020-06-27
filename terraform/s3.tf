resource "aws_s3_bucket" "grainstore_bucket" {
  bucket = local.bucket_name
  acl    = "private"

  versioning {
    enabled = true
  }

  # TODO switch to KMS CMK if prod
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    Name        = local.bucket_name
    Environment = "${var.environment}"
  }

  # Ignore logging warning from tfsec scan for this bucket
  #tfsec:ignore:AWS002

}

resource "aws_s3_bucket_public_access_block" "grainstore_access_block" {
  bucket = aws_s3_bucket.grainstore_bucket.id

  # Block new public ACLs and uploading public objects
  block_public_acls = true

  # Retroactively remove public access granted through public ACLs
  ignore_public_acls = true

  # Block new public bucket policies
  block_public_policy = true

  # Retroactivley block public and cross-account access if bucket has public policies
  restrict_public_buckets = true
}

# Public bucket for temp hosting of images
resource "aws_s3_bucket" "grainstore_public_bucket" {
  bucket = local.public_bucket_name
  acl    = "public-read"

  versioning {
    enabled = false
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  lifecycle_rule {
    id      = "imagecleanup"
    enabled = true

    prefix = "img/"

    expiration {
      days = 1
    }
  }

  website {
    index_document = "index.html"
    error_document = "error.htlm"
  }

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET"]
    # TODO lock this down to known website endpoint
    allowed_origins = ["*"]
    max_age_seconds = 3000
  }

  # All data in this bucket is ephemeral
  force_destroy = true

  tags = {
    Name        = local.public_bucket_name
    Environment = "${var.environment}"
  }
}

resource "aws_s3_bucket_public_access_block" "grainstore_public_access_block" {
  bucket = aws_s3_bucket.grainstore_public_bucket.id

  # Block new public ACLs and uploading public objects
  block_public_acls = false

  # Retroactively remove public access granted through public ACLs
  ignore_public_acls = false

  # Block new public bucket policies
  block_public_policy = false

  # Retroactivley block public and cross-account access if bucket has public policies
  restrict_public_buckets = false
}

resource "aws_s3_bucket_object" "index_file" {
  bucket        = aws_s3_bucket.grainstore_public_bucket.id
  key           = "index.html"
  source        = "htmlfiles/index.html"
  acl           = "public-read"
  etag          = filemd5("htmlfiles/index.html")
  storage_class = "ONEZONE_IA"
}

resource "aws_s3_bucket_object" "error_file" {
  bucket        = aws_s3_bucket.grainstore_public_bucket.id
  key           = "error.html"
  source        = "htmlfiles/error.html"
  acl           = "public-read"
  etag          = filemd5("htmlfiles/error.html")
  storage_class = "ONEZONE_IA"
}