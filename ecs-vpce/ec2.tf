resource "aws_lb" "alb" {
  name               = "${local.project_name}-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [aws_subnet.public-1a.id, aws_subnet.public-1c.id]
  security_groups    = [aws_security_group.alb-sg.id]

  tags = {
    Name = "${local.project_name}-alb"
  }
}

resource "aws_lb_listener" "alb-listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb-tg.arn
  }
}

resource "aws_lb_target_group" "alb-tg" {
  name        = "${local.project_name}-alb-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"

  health_check {
    healthy_threshold = 2
  }
}

output "alb-url" {
  value = aws_lb.alb.dns_name
}
