# IAM:

# Create an IAM role for the Web Servers.
resource "aws_iam_role" "dtr_iam_role" {
  name = "${var.deployment}_dtr_iam_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
  tags = {
    yor_trace = "960f64fa-9d6b-4fdc-98ba-871eeb106ad4"
  }
}

resource "aws_iam_instance_profile" "dtr_instance_profile" {
  name = "${var.deployment}_dtr_instance_profile"
  role = "${aws_iam_role.dtr_iam_role.id}"
  tags = {
    yor_trace = "26acfc5d-3c87-4ba1-98b3-22172a32bcd7"
  }
}

resource "aws_iam_role_policy" "dtr_iam_role_policy" {
  name = "${var.deployment}_dtr_iam_role_policy"
  role = "${aws_iam_role.dtr_iam_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:CreateTags",
        "ec2:DescribeTags",

        "ec2:CreateSnapshot",
        "ec2:DeleteSnapshot",
        "ec2:DescribeSnapshots",

        "ec2:CreateVolume",
        "ec2:DeleteVolume",
        "ec2:DescribeVolumes",
        "ec2:AttachVolume",
        "ec2:DetachVolume",

        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "cloudwatch:PutMetricData"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket",
        "s3:GetBucketLocation",
        "s3:ListAllMyBuckets",
        "s3:ListBucketMultipartUploads"
       ],
      "Resource": ["arn:aws:s3:::${aws_s3_bucket.dtr_storage_bucket.id}"]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:PutObject",
        "s3:DeleteObject",
        "s3:ListMultipartUploadParts",
        "s3:AbortMultipartUpload"
      ],
      "Resource": ["arn:aws:s3:::${aws_s3_bucket.dtr_storage_bucket.id}/*"]
    }
  ]
}
EOF
}
