resource "aws_s3_bucket" "front" {
  # バケット名は全アカウントで一意になる必要があるので、uuidをsuffixにする
  # sh -c 'echo "s3-cloudfront-$(uuidgen)"'
  bucket = "s3-cloudfront-40e6b52b-aa09-f5a3-8f46-a16fb75170ea"

  tags = {
    Name = "Front Bucket"
  }
}

resource "aws_s3_bucket_acl" "front_acl" {
  bucket = aws_s3_bucket.front.id
  acl    = "private"
}

resource "aws_s3_bucket_policy" "bucket" {
  bucket = aws_s3_bucket.front.id
  policy = data.aws_iam_policy_document.static-www.json
}

data "aws_iam_policy_document" "static-www" {
  statement {
    sid    = "Allow CloudFront"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.oai.iam_arn]
    }
    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${aws_s3_bucket.front.arn}/*"
    ]
  }
}
