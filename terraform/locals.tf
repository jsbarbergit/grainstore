locals {
  table_name         = "grainstore-data-${var.environment}"
  bucket_name        = "grainstore-bucket-${var.environment}"
  public_bucket_name = "grainstore-public-bucket-${var.environment}"
}