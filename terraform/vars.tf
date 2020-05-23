variable "aws_region" {
  description = "The AWS region to create resources in"
  default     = "eu-west-2"
}

variable "cibuild_assumerole" {
  description = "Build IAM Role"
  default     = "arn:aws:iam::146964078495:role/TerraformBuildRole"
}