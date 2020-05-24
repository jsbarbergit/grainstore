variable "aws_region" {
  description = "The AWS region to create resources in"
  default     = "eu-west-2"
}

variable "cibuild_assumerole" {
  description = "Build IAM Role"
  default     = "arn:aws:iam::146964078495:role/TerraformBuildRole"
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