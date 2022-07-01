output "s3-bucket-path" {
  value = aws_s3_bucket.front.bucket
}

output "cloudfront-url" {
  value = "https://${aws_cloudfront_distribution.s3_distribution.domain_name}"
}
