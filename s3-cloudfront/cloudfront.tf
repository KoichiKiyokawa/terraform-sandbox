resource "aws_cloudfront_origin_access_identity" "oai" {}

resource "aws_cloudfront_distribution" "s3_distribution" {
  enabled             = true
  default_root_object = "index.html"
  origin {
    domain_name = aws_s3_bucket.front.bucket_regional_domain_name
    origin_id   = aws_s3_bucket.front.id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
    }
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    viewer_protocol_policy = "redirect-to-https"
    target_origin_id       = aws_s3_bucket.front.id

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }


  viewer_certificate {
    cloudfront_default_certificate = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}
