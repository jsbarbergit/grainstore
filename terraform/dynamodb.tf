resource "aws_dynamodb_table" "grainstore_table" {
  name           = local.table_name
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "CustomerId"
  range_key      = "UUID"

  # TBC Name of client buying/selling the grain
  attribute {
    name = "CustomerId"
    type = "S"
  }

  # TBC Grainstore Customer ID - assumes shared table for now - may well be table per customer eventually 
  attribute {
    name = "UUID"
    type = "S"
  }

  server_side_encryption {
    enabled = true
    # TODO for prod use - specify kms cmk
    #   kms_key_arn = ""    
  }

  point_in_time_recovery {
    enabled = var.dynamo_pitr
  }

  tags = {
    Name        = "grainstore-data-${var.environment}"
    Environment = var.environment
  }
}