{
  "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowCreateLogGroup",
            "Effect": "Allow",
            "Action": "logs:CreateLogGroup",
            "Resource": "*"
        },
        {
            "Action": [
                "logs:PutLogEvents",
                "logs:CreateLogStream",
                "logs:DescribeLogStreams"
            ],
            "Resource": [
                "arn:aws:logs:${aws_region}:${account_id}:log-group:/aws/lambda/GrainstoreSignedUrl"
            ],
            "Effect": "Allow"
        },
        {
            "Sid": "AllowS3ListBuckets",
            "Effect": "Allow",
            "Action": [
                "s3:ListAllMyBuckets",
                "s3:HeadBucket"
            ],
            "Resource": "*"
        },
        {
          "Sid": "S3UploadPermissions",
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:PutObjectVersionAcl",
                "s3:PutObjectVersionTagging",
                "s3:ListBucket",
                "s3:PutObjectTagging",
                "s3:PutObjectAcl"
            ],
            "Resource": [
                "arn:aws:s3:::grainstore-bucket",
                "arn:aws:s3:::grainstore-bucket/*"
            ]
        }
    ]
}