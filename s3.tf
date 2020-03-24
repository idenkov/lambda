resource "aws_s3_bucket" "s3-bucket" {
  bucket        = "s3-lambda-static"
  acl           = "public-read"
  policy        = file("policy.json")
  force_destroy = true

  website {
    index_document = "index.html"
  }
}