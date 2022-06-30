resource "aws_ecs_cluster" "cicd-bootcamp-cluster" {
  name = "cicd-bootcamp-cluster"
}


resource "aws_ecs_task_definition" "cicd-bootcamp-task" {
  family                   = "cicd-bootcamp-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 4096
  memory                   = 8192
  execution_role_arn       = aws_iam_role.fargate-exec-role.arn
  depends_on = [
    null_resource.build-push
  ]
  container_definitions = jsonencode([
    {
      name  = "nginx"
      image = "${aws_ecr_repository.nginx.repository_url}:${var.image-tag}"
      portMappings = [
        {
          hostPort      = 80
          containerPort = 80
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.log-nginx.name
          awslogs-region        = data.aws_region.current.name
          awslogs-stream-prefix = "nginx"
        }
      }
      depends_on = [
        {
          container_name = "app"
          condition      = "START"
        }
      ]
    },
    {
      name  = "app"
      image = "${aws_ecr_repository.app.repository_url}:${var.image-tag}"
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.log-app.name
          awslogs-region        = data.aws_region.current.name
          awslogs-stream-prefix = "app"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "main" {
  name            = "${local.project_name}-server"
  cluster         = aws_ecs_cluster.cicd-bootcamp-cluster.id
  task_definition = aws_ecs_task_definition.cicd-bootcamp-task.id
  desired_count   = 2
  launch_type     = "FARGATE"

  load_balancer {
    target_group_arn = aws_lb_target_group.alb-tg.arn
    container_name   = "nginx"
    container_port   = 80
  }

  network_configuration {
    subnets         = [aws_subnet.private-1a.id, aws_subnet.private-1c.id]
    security_groups = [aws_security_group.web-sg.id]
  }
}
