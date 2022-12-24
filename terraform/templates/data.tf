# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ecr_repository
data "aws_ecr_repository" "repository" {
  name = var.ecr_repository_name
}