resource "aws_cloudwatch_log_group" "log-nginx" {
  name = "/ecs/cici-bootcamp/nginx"
}

resource "aws_cloudwatch_log_group" "log-app" {
  name = "/ecs/cici-bootcamp/app"
}