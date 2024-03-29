resource "aws_cloudfront_distribution" "s3_website" {
  enabled = true
  is_ipv6_enabled = true
  comment = "S3 bucket distribution"
  default_root_object = "index.html"

  origin {
    domain_name = aws_s3_bucket.bucket.bucket_regional_domain_name
    origin_id = "my-s3-origin"
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
  }

  default_cache_behavior {
    viewer_protocol_policy = "redirect-to-https"
    min_ttl = 0
    default_ttl = 3600
    max_ttl = 86400

    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods = ["GET", "HEAD"]
    target_origin_id = "my-s3-origin"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

viewer_certificate {
  cloudfront_default_certificate = true
}
}

resource "aws_cloudfront_origin_access_control" "oac" {
  name = "cloudfront OAC"
  description = "Cloudfront Origin Access Control"
  origin_access_control_origin_type = "s3"
  signing_behavior = "always"
  signing_protocol = "sigv4"
}