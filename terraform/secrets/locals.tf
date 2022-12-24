locals {
  key_file_pem = "${var.project_dir}/${var.project_name}.pem"

  registry_server = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com"

  kubectl_vars = {
    aws_access_key_id     = var.aws_access_key_id
    aws_secret_access_key = var.aws_secret_access_key

    aws_region    = var.aws_region
    docker_server = "https://${local.registry_server}"

    # ssh_private_key     = base64encode(data.local_file.key_file_pem.content)
    # auth_token_password = base64encode("AWS:${data.aws_ecr_authorization_token.auth_token.password}")
    github_token = var.github_token

    docker_config_json = base64encode(jsonencode({
      auths = {
        "${local.registry_server}" = {
          "username" = "AWS"
          "password" = data.aws_ecr_authorization_token.auth_token.password
          "auth"     = base64encode("AWS:${data.aws_ecr_authorization_token.auth_token.password}")
        }
      }
    }))
  }
}