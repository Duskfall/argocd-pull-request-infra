output "project_name" {
  value = var.project_name
}

output "ecr_repository_name" {
  value = var.ecr_repository_name
}

output "github_repo_url_infra" {
  value = var.github_repo_url_infra
}

output "aws_region" {
  value = var.aws_region
}

output "repository_url" {
  value = data.aws_ecr_repository.repository.repository_url
}

output "github_owner" {
  value = var.github_owner
}

output "github_repo_name_vote" {
  value = var.github_repo_name_vote
}