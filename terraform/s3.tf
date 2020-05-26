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
    Name        = "grainstore-data-${var.environment}"
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