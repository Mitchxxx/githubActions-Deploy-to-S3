resource "aws_s3_bucket" "bucket" {
  bucket = "deploy-to-s3"
  force_destroy = true
  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_s3_bucket_policy" "bucket-policy" {
  bucket = aws_s3_bucket.bucket.id
  policy = jsonencode({
    "version": "2012-10-17",
    "Statement": [
      {
        "Sid": "AllowTrustEntity",
        "Effect": "Allow",
        "Principal": {
          "AWS": "arn:aws:iam::748527796092:role/gitHubRole"
        },
        "Action": ["s3:GetObject"],
        "Resource": ["arn:aws:s3:::mitch-gitlab-cicd/*"]
      },
      {
        "Sid": "AllowTrustEntity",
        "Effect": "Allow",
        "Principal": {
          "Service": "cloudfront.amazonaws.com"
        },
        "Action": ["s3:GetObject"],
        "Resource": ["arn:aws:s3:::mitch-gitlab-cicd/*"],
        "Condition": {
          "StringEquals": {
            "aws:SourceArn": "arn:aws:cloudfront::Action-ID:distribution/${aws_cloudfront_distribution.s3_website.id}"
          }
        }
      }
    ]
  })
}

resource "aws_s3_bucket_website_configuration" "web-bucket" {
  bucket = aws_s3_bucket.bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_ownership_controls" "web-bucket" {
  bucket = aws_s3_bucket.bucket.id
  rule {
    object_ownership = "BucketOwnerPrefered"
  }
}

resource "aws_s3_bucket_public_access_block" "s3-bucket-access" {
  bucket = aws_s3_bucket.bucket.id
  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_acl" "web-bucket" {
  bucket = aws_s3_bucket.bucket.id
  acl = "private"
  depends_on = [ aws_s3_bucket_ownership_controls.web-bucket ]
}

resource "aws_s3_object" "object_html" {
    for_each = fileset("src/", "*.html")
    bucket = aws_s3_bucket.bucket.id
    key = each.value
    source = "src/${each.value}"
    etag = filemd5("src/${each.value}")
    content_type = "text.html"
}