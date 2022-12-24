# https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource
resource "null_resource" "env_file" {

  triggers = {
    # everytime = uuid()
    rarely = join("-", [
      aws_iam_access_key.user_key.id,
      aws_iam_access_key.user_key.secret,
      aws_ecr_repository.repository.repository_url
    ])
  }

  # https://developer.hashicorp.com/terraform/language/resources/provisioners/local-exec
  provisioner "local-exec" {
    command = "scripts/env-file.sh .env AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY ECR_REPOSITORY_URL"

    working_dir = var.project_dir

    environment = {
      AWS_ACCESS_KEY_ID     = aws_iam_access_key.user_key.id
      AWS_SECRET_ACCESS_KEY = aws_iam_access_key.user_key.secret
      ECR_REPOSITORY_URL    = aws_ecr_repository.repository.repository_url
    }
  }
}
