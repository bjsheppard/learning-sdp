resource "aws_ecr_repository" "dev_repo" {
  name = "mhausenblas/simpleservice"
}

resource "aws_ecr_repository" "nginx" {
  name = "nginx"
}