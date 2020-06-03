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
                "arn:aws:logs:${aws_region}:${account_id}:*"
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