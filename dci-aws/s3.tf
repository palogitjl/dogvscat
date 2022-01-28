# S3 Bucket:

resource "aws_s3_bucket" "dtr_storage_bucket" {
  bucket_prefix = "${lower(var.deployment)}-dtrstorage-"
  acl           = "private"

  tags {
    Name        = "${var.deployment}-DTRStorage"
    Environment = "${var.deployment}"
  }
  tags = {
    yor_trace = "cb4e5745-9a31-4e13-b274-5557215cb84c"
  }
}
