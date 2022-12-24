output "project_dir" {
  value = var.project_dir
}

output "project_name" {
  value = var.project_name
}

output "ecr_repository_name" {
  value = var.ecr_repository_name
}

output "aws_region" {
  value = var.aws_region
}

output "github_owner" {
  value = var.github_owner
}

output "github_repo_name_vote" {
  value = var.github_repo_name_vote
}

output "github_repo_name_infra" {
  value = var.github_repo_name_infra
}


# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository#repository_url
output "ecr_repository_url" {
  value = aws_ecr_repository.repository.repository_url
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository#arn
output "ecr_repository_arn" {
  value = aws_ecr_repository.repository.arn
}
