terraform {
  required_version = "0.12.25"
}

provider "aws" {
  region  = var.aws_region
  version = "~> 2.63"

  assume_role {
    role_arn = var.cibuild_assumerole
    session_name = "TerraformBuild"
  }
}
