output "cloudfront_url" {
  value = "https://${aws_cloudfront_distribution.s3_website.domain.name}"
}

output "distribution_url" {
  value = aws_cloudfront_distribution.s3_website
}