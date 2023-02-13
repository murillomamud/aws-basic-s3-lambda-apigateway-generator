resource "aws_s3_bucket" "project-bucket" {
  bucket        = "{project_name}"
  force_destroy = true
}

resource "aws_s3_bucket_ownership_controls" "project-bucket-ownership" {
  bucket = aws_s3_bucket.project-bucket.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}