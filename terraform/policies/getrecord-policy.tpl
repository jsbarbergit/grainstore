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
            "Sid": "DynamoDBReadPermissions",
            "Action": [
                "dynamodb:BatchGetItem",
                "dynamodb:ConditionCheckItem",
                "dynamodb:DescribeTable",
                "dynamodb:ListTables",
                "dynamodb:GetShardIterator",
                "dynamodb:GetItem",
                "dynamodb:Scan",
                "dynamodb:Query",
                "dynamodb:DescribeTimeToLive",
                "dynamodb:GetRecords"
            ],
            "Resource": [
                "${dynamo_arn}"
            ],
            "Effect": "Allow"
        }
    ]
}