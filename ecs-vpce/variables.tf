# 内部でしか使えない。定数みたいなもの
locals {
  project_name = "cicd-bootcamp"
  my_ip        = "111.108.92.1"
}

# 外から受け取れる
variable "image-tag" {
  type    = string
  default = "latest"
}

data "aws_region" "current" {}
data "aws_caller_identity" "self" {}
