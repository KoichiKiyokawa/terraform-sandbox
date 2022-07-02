resource "aws_cloudfront_origin_access_identity" "oai" {}

resource "aws_cloudfront_distribution" "s3_distribution" {
  enabled             = true
  default_root_object = "index.html"
  origin {
    domain_name = aws_s3_bucket.front.bucket_regional_domain_name
    origin_id   = aws_s3_bucket.front.id

    # S3に直接アクセスできないようにOAIを設定する
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
    }
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    viewer_protocol_policy = "redirect-to-https"
    target_origin_id       = aws_s3_bucket.front.id
    compress = true
    cache_policy_id        = aws_cloudfront_cache_policy.cache_policy.id
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

resource "aws_cloudfront_cache_policy" "cache_policy" {
  name    = "compressed-policy"
  min_ttl = 0
  parameters_in_cache_key_and_forwarded_to_origin {
    # brotliでの圧縮を有効にする
    enable_accept_encoding_brotli = true
    cookies_config {
      cookie_behavior = "none"

    }
    headers_config {
      header_behavior = "none"
    }
    query_strings_config {
      query_string_behavior = "none"
    }
  }
}
