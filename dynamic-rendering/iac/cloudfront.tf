resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "oac"
  description                       = "Origin Access Control"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = aws_s3_bucket.front.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
    origin_id                = local.s3_origin_id
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Dynamic rendering"
  default_root_object = "index.html"

  logging_config {
    include_cookies = false
    bucket          = "${aws_s3_bucket.front_log.bucket}.s3.amazonaws.com"
    prefix          = "front"
  }

  # aliases = ["mysite.example.com", "yoursite.example.com"]

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400

    function_association {
      event_type   = "viewer-request"
      function_arn = aws_cloudfront_function.bot_detection.arn
    }

    lambda_function_association {
      event_type = "origin-request"
      lambda_arn = aws_lambda_function.prerenderer.qualified_arn
    }
  }

  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Environment = "production"
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

# resource "null_resource" "build" {
#   triggers = {
#     always = timestamp()
#   }
#   provisioner "local-exec" {
#     command     = "pnpm i && pnpm run build"
#     working_dir = "${path.module}/../functions"
#   }
# }

resource "local_file" "viewer_request_build_output" {
  source   = "${path.module}/../functions/viewer-request.js"
  filename = "${path.module}/../functions/viewer-request.js"
  # depends_on = [
  #   null_resource.build
  # ]
}

resource "aws_cloudfront_function" "bot_detection" {
  name    = "bot-detection"
  runtime = "cloudfront-js-1.0"
  publish = true
  code    = file(local_file.viewer_request_build_output.source)
}
