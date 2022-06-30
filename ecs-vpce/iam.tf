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
  tags = {
    Name = "fargate-exec-role"
  }
}


resource "aws_iam_role_policy_attachment" "att" {
  role       = aws_iam_role.fargate-exec-role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
