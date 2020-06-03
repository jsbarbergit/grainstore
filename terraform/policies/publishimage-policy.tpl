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
                "arn:aws:logs:${aws_region}:${account_id}:log-group:/aws/lambda/GrainstorePublishImage-${environment}"
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
          "Sid": "S3ReadPermissions",
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:GetObjectAcl",
                "s3:GetObjectVersion",
                "s3:GetObjectVersionAcl",
                "s3:ListBucket",
                "s3:PutObjectTagging",
                "s3:PutObjectAcl"
            ],
            "Resource": [
                "arn:aws:s3:::${bucket_name}",
                "arn:aws:s3:::${bucket_name}/*"
            ]
        },
        {
          "Sid": "S3Writepermissions",
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:PutObjectAcl",
                "s3:PutObjectVersion",
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::${public_bucket_name}",
                "arn:aws:s3:::${public_bucket_name}/*"
            ]
        }
    ]
}