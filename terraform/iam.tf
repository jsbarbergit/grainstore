data "aws_caller_identity" "current" {}

# IAM Role for Cognito Login Lambda Function
resource "aws_iam_policy" "cognito_login_policy" {
  name = "CognitoLambdaPolicy-${var.environment}"

  policy = templatefile("${path.module}/policies/cognito-login-policy.tpl", {
    aws_region  = var.aws_region,
    account_id  = data.aws_caller_identity.current.account_id,
    environment = var.environment
  })
}

resource "aws_iam_role" "cognito_login_role" {
  name               = "CognitoLambdaRole-${var.environment}"
  assume_role_policy = templatefile("${path.module}/policies/lambda-assumerole-policy.tpl", {})
}

resource "aws_iam_role_policy_attachment" "cognito_login_policy_attachment" {
  policy_arn = aws_iam_policy.cognito_login_policy.arn
  role       = aws_iam_role.cognito_login_role.name
}

# IAM Role for Pre Signed URL Function
resource "aws_iam_policy" "grainstore_signed_url_policy" {
  name = "GrainstoreSignedUrlLambdaPolicy-${var.environment}"
  policy = templatefile("${path.module}/policies/getsignedurl-policy.tpl", {
    aws_region  = var.aws_region,
    account_id  = data.aws_caller_identity.current.account_id,
    environment = var.environment
  })
}

resource "aws_iam_role" "grainstore_signed_url_role" {
  name = "GrainstoreSignedUrlRole-${var.environment}"

  assume_role_policy = templatefile("${path.module}/policies/lambda-assumerole-policy.tpl", {})
}

resource "aws_iam_role_policy_attachment" "grainstore_signed_url_policy_attachment" {
  policy_arn = aws_iam_policy.grainstore_signed_url_policy.arn
  role       = aws_iam_role.grainstore_signed_url_role.name
}

# IAM Role for Add Record Function
resource "aws_iam_policy" "grainstore_add_record_policy" {
  name = "GrainstoreAddRecordLambdaPolicy-${var.environment}"

  policy = templatefile("${path.module}/policies/addrecord-policy.tpl", {
    aws_region  = var.aws_region,
    account_id  = data.aws_caller_identity.current.account_id,
    environment = var.environment,
    dynamo_arn  = aws_dynamodb_table.grainstore_table.arn
  })
}

resource "aws_iam_role" "grainstore_add_record_role" {
  name = "GrainstoreAddRecordRole-${var.environment}"

  assume_role_policy = templatefile("${path.module}/policies/lambda-assumerole-policy.tpl", {})
}

resource "aws_iam_role_policy_attachment" "grainstore_add_record_policy_attachment" {
  policy_arn = aws_iam_policy.grainstore_add_record_policy.arn
  role       = aws_iam_role.grainstore_add_record_role.name
}

# IAM Role for Get Record Function
resource "aws_iam_policy" "grainstore_get_record_policy" {
  name = "GrainstoreGetRecordLambdaPolicy-${var.environment}"

  policy = templatefile("${path.module}/policies/getrecord-policy.tpl", {
    aws_region  = var.aws_region,
    account_id  = data.aws_caller_identity.current.account_id,
    environment = var.environment,
    dynamo_arn  = aws_dynamodb_table.grainstore_table.arn
  })
}

resource "aws_iam_role" "grainstore_get_record_role" {
  name = "GrainstoreGetRecordRole-${var.environment}"

  assume_role_policy = templatefile("${path.module}/policies/lambda-assumerole-policy.tpl", {})
}

resource "aws_iam_role_policy_attachment" "grainstore_get_record_policy_attachment" {
  policy_arn = aws_iam_policy.grainstore_get_record_policy.arn
  role       = aws_iam_role.grainstore_get_record_role.name
}

# IAM Role for Publish Image Function
resource "aws_iam_policy" "grainstore_publish_image_policy" {
  name = "GrainstorePublishImageLambdaPolicy-${var.environment}"

  policy = templatefile("${path.module}/policies/publishimage-policy.tpl", {
    aws_region         = var.aws_region,
    account_id         = data.aws_caller_identity.current.account_id,
    environment        = var.environment,
    bucket_name        = local.bucket_name,
    public_bucket_name = local.public_bucket_name
  })
}

resource "aws_iam_role" "grainstore_publish_image_role" {
  name = "GrainstorePublishImageRole-${var.environment}"

  assume_role_policy = templatefile("${path.module}/policies/lambda-assumerole-policy.tpl", {})
}

resource "aws_iam_role_policy_attachment" "grainstore_publish_image_policy_attachment" {
  policy_arn = aws_iam_policy.grainstore_publish_image_policy.arn
  role       = aws_iam_role.grainstore_publish_image_role.name
}