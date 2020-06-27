resource "aws_dynamodb_table" "grainstore_table" {
  name           = local.table_name
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = var.grainstore_data_partition_key_name
  range_key      = var.grainstore_data_sort_key_name

  # UUID for optimised 
  attribute {
    name = var.grainstore_data_partition_key_name
    type = "S"
  }

  # TBC Grainstore Customer ID - assumes shared table for now - may well be table per customer eventually 
  attribute {
    name = var.grainstore_data_sort_key_name
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