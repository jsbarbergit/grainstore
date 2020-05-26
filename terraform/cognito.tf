resource "aws_cognito_user_pool" "pool" {
  name = "grainstore-${var.environment}"

  schema {
    attribute_data_type = var.schema_attribute_data_type
    name                = var.schema_name
    required            = var.schema_required
    mutable             = true

    string_attribute_constraints {
      min_length = var.schema_attribute_constraint_min_length
      max_length = var.schema_attribute_constraint_max_length
    }
  }

  admin_create_user_config {
    allow_admin_create_user_only = true
    unused_account_validity_days = var.unused_account_expiry_days
    invite_message_template {
      email_subject = "Grainstore Access"
      email_message = "Your Grainstore username is {username} and temporary password is {####}"
      sms_message   = "Your username is {username} and password is {####}"
    }
  }

  verification_message_template {
    email_subject = "Grainstore Access (${var.environment})"
    email_message = "Your Grainstore username is {username} and password is {####}"
  }

  auto_verified_attributes = var.auto_verified_attributes
}

resource "aws_cognito_user_pool_client" "client" {
  name                = "grainstore_client_${var.environment}"
  user_pool_id        = aws_cognito_user_pool.pool.id
  generate_secret     = true
  explicit_auth_flows = ["ADMIN_NO_SRP_AUTH"]
}