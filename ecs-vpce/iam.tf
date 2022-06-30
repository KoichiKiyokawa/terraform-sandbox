resource "aws_iam_role" "fargate-exec-role" {
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        },
        Action = [
          "sts:AssumeRole"
        ],
      },
    ]
  })
}

resource "aws_iam_policy" "fargate-exec-role-policy" {
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "s3:*"
        ],
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "att" {
  role       = aws_iam_role.fargate-exec-role.name
  policy_arn = aws_iam_policy.fargate-exec-role-policy.arn
}
