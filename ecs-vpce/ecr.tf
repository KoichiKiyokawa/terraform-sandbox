resource "aws_ecr_repository" "nginx" {
  name = "${local.project_name}-nginx"
}

resource "aws_ecr_repository" "app" {
  name = "${local.project_name}-app"
}

resource "null_resource" "build-push" {
  provisioner "local-exec" {
    command = file("./scripts/build-push.sh")
    environment = {
      NGINX_REGISTORY_URI = aws_ecr_repository.nginx.repository_url
      APP_REGISTORY_URI   = aws_ecr_repository.app.repository_url
      AWS_REGION          = data.aws_region.current.name
      AWS_ACCOUNT_ID      = data.aws_caller_identity.self.account_id
    }
    on_failure = fail
  }
}
