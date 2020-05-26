data "aws_caller_identity" "current" {}

# IAM Role for Cognito Login Lambda Function
resource "aws_iam_policy" "cognito_login_policy" {
  name = "CognitoLambdaPolicy"

  policy = templatefile("${path.module}/policies/cognito-login-policy.tpl", {
    aws_region = var.aws_region,
    account_id = data.aws_caller_identity.current.account_id
  })
}

resource "aws_iam_role" "cognito_login_role" {
  name               = "CognitoLambdaRole"
  assume_role_policy = templatefile("${path.module}/policies/lambda-assumerole-policy.tpl", {})
}

resource "aws_iam_role_policy_attachment" "cognito_login_policy_attachment" {
  policy_arn = aws_iam_policy.cognito_login_policy.arn
  role       = aws_iam_role.cognito_login_role.name
}

# IAM Role for Add Record Function
resource "aws_iam_policy" "grainstore_add_record_policy" {
  name = "GrainstoreAddRecordLambdaPolicy"

  policy = templatefile("${path.module}/policies/addrecord-policy.tpl", {
    aws_region = var.aws_region,
    account_id = data.aws_caller_identity.current.account_id
  })
}

resource "aws_iam_role" "grainstore_add_record_role" {
  name = "GrainstoreAddRecordRole"

  assume_role_policy = templatefile("${path.module}/policies/lambda-assumerole-policy.tpl", {})
}

resource "aws_iam_role_policy_attachment" "grainstore_add_record_policy_attachment" {
  policy_arn = aws_iam_policy.grainstore_add_record_policy.arn
  role       = aws_iam_role.grainstore_add_record_role.name
}

# IAM Role for Pre Signed URL Function
resource "aws_iam_policy" "grainstore_signed_url_policy" {
  name = "GrainstoreSignedUrlLambdaPolicy"
  policy = templatefile("${path.module}/policies/getsignedurl-policy.tpl", {
    aws_region = var.aws_region,
    account_id = data.aws_caller_identity.current.account_id
  })
}

resource "aws_iam_role" "grainstore_signed_url_role" {
  name = "GrainstoreSignedUrlRole"

  assume_role_policy = templatefile("${path.module}/policies/lambda-assumerole-policy.tpl", {})
}

resource "aws_iam_role_policy_attachment" "grainstore_signed_url_policy_attachment" {
  policy_arn = aws_iam_policy.grainstore_signed_url_policy.arn
  role       = aws_iam_role.grainstore_signed_url_role.name
}