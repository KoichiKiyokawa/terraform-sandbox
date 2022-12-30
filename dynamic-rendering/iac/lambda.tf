resource "aws_iam_role" "lambda_edge" {
  name = "lambda-edge"

  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com", "edgelambda.amazonaws.com"]
    }
  }
}

data "archive_file" "prerenderer" {
  type        = "zip"
  source_dir  = "${path.module}/../functions/origin-request"
  output_path = "dist/origin-request.zip"
}

provider "aws" {
  region = "us-east-1"
  alias  = "virginia"
}

resource "aws_lambda_function" "prerenderer" {
  provider      = aws.virginia
  runtime       = "nodejs18.x"
  function_name = "prerenderer"
  filename      = data.archive_file.prerenderer.output_path
  role          = aws_iam_role.lambda_edge.arn
  handler       = "index.handler"
  publish       = true
}
