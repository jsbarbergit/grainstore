# IAM Role for Cognito Login Lambda Function
resource "aws_iam_policy" "cognito_login_policy" {
  name = "CognitoLambdaPolicy"

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "logs:CreateLogGroup",
                "logs:PutLogEvents",
                "logs:CreateLogStream",
                "logs:DescribeLogStreams"
            ],
            "Resource": [
                "arn:aws:logs:*:*:*"
            ],
            "Effect": "Allow"
        },
        {
            "Action": [
                "cognito-idp:ListUsersInGroup",
                "cognito-idp:ListGroups",
                "cognito-idp:ListDevices",
                "cognito-idp:ListUserPools",
                "cognito-idp:ListUserPoolClients",
                "cognito-idp:ListUserImportJobs",
                "cognito-idp:ListUsers",
                "cognito-idp:UpdateUserPoolClient",
                "cognito-idp:UpdateUserPool",
                "cognito-idp:DescribeUserPool",
                "cognito-idp:DescribeUserPoolClient",
                "cognito-idp:AdminInitiateAuth",
                "cognito-idp:AdminSetUserPassword"
            ],
            "Resource": "*",
            "Effect": "Allow"
        }
    ]
}
POLICY
}

resource "aws_iam_role" "cognito_login_role" {
  name = "CognitoLambdaRole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "lambda.amazonaws.com",
          "edgelambda.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "cognito_login_policy_attachment" {
  policy_arn = aws_iam_policy.cognito_login_policy.arn
  role       = aws_iam_role.cognito_login_role.name
}
