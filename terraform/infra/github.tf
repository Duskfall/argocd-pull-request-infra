# https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_secret
resource "github_actions_secret" "secret_key_id" {
  repository      = var.github_repo_name_vote
  secret_name     = "AWS_ACCESS_KEY_ID"
  plaintext_value = aws_iam_access_key.user_key.id
}

# https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_secret
resource "github_actions_secret" "secret_access_key" {
  repository      = var.github_repo_name_vote
  secret_name     = "AWS_SECRET_ACCESS_KEY"
  plaintext_value = aws_iam_access_key.user_key.secret
}

resource "github_actions_secret" "github_token" {
  repository = var.github_repo_name_vote
  # a secret starting with GITHUB_ is not allowed 
  secret_name     = "GH_TOKEN"
  plaintext_value = var.github_token
}

resource "github_actions_secret" "aws_region" {
  repository      = var.github_repo_name_vote
  secret_name     = "AWS_REGION"
  plaintext_value = var.aws_region
}

resource "github_actions_secret" "repository_infra" {
  repository      = var.github_repo_name_vote
  secret_name     = "GH_REPOSITORY_INFRA"
  plaintext_value = "${var.github_owner}/${var.github_repo_name_infra}"
}