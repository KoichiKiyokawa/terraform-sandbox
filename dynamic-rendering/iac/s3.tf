locals {
  s3_origin_id = "dynamic-rendering-eoiajwofnalfn"
}

resource "aws_s3_bucket" "front" {
  bucket        = local.s3_origin_id
  force_destroy = true

  tags = {
    Name = "Dynamic Rendering"
  }
}

resource "aws_s3_bucket" "front_log" {
  bucket        = "dynamic-rendering-loglogoiejaojgoa"
  force_destroy = true

  tags = {
    Name = "Dynamic Rendering"
  }
}

resource "aws_s3_bucket_public_access_block" "main" {
  bucket                  = aws_s3_bucket.front.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "front" {
  bucket = aws_s3_bucket.front.id
  policy = data.aws_iam_policy_document.s3_main_policy.json
}

data "aws_iam_policy_document" "s3_main_policy" {
  # CloudFront Distribution からのアクセスのみ許可
  statement {
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.front.arn}/*"]
    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = [aws_cloudfront_distribution.s3_distribution.arn]
    }
  }
}
