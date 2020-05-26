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
        }
    ]
}