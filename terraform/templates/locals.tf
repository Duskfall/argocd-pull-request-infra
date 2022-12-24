locals {
  # repository_name = format("%s-%s", var.project_name, var.app_name)

  # xxx.dkr.ecr.xxx.amazonaws.com/xxx
  repository_url = data.aws_ecr_repository.repository.repository_url

  template_vars = {
    project_name          = var.project_name
    github_repo_url_infra = var.github_repo_url_infra
    github_owner          = var.github_owner
    github_repo_name_vote = var.github_repo_name_vote

    vote_namespace = "vote"
    vote_nodeport  = 30000
    vote_image     = "${local.repository_url}:0.0.1"
    vote_version   = "0.0.1"
    # website_image = "${local.repository_url}:0.0.1"
    # git_repo_url  = var.github_repo
  }
}