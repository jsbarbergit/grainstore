variable "aws_region" {
  description = "The AWS region to create resources in"
  default     = "eu-west-2"
}

variable "cibuild_assumerole" {
  description = "Build IAM Role"
  default     = "arn:aws:iam::146964078495:role/TerraformBuildRole"
}

# Environment var
variable "environment" {
  default     = ""
  description = "Environment name - will be used as a prefix for all resources. Must be passed at build time"
}

# User Pool Vars
variable "schema_attribute_data_type" {
  default = "String"
}

variable "schema_name" {
  default = "email"
}

variable "schema_required" {
  default = true
}

variable "schema_attribute_constraint_min_length" {
  default     = 0
  description = "Min length of schema attribute - required to prevent TF creating replacement resources"
}

variable "schema_attribute_constraint_max_length" {
  default     = 2048
  description = "Max length of schema attribute - required to prevent TF creating replacement resources"
}

variable "unused_account_expiry_days" {
  default     = 14
  description = "Number of days after which unclaimed new accounts expire"
}

variable "auto_verified_attributes" {
  type    = list(string)
  default = ["email"]
}

# Cloudwatch log vars
variable "log_retention_days" {
  default     = "7"
  description = "Days to keep CW Log data for Lambda functions"
}

# DynamoDB Vars
variable "grainstore_data_partition_key_name" {
  default = "UUID"
}
variable "grainstore_data_sort_key_name" {
  default = "CustomerId"
}

variable "dynamo_pitr" {
  default     = true
  type        = bool
  description = "Enable PITR for grainstore dynamodb data table"
}