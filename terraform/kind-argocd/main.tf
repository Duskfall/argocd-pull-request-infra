# https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource
resource "null_resource" "env_file" {

  triggers = {
    # everytime = uuid()
    rarely = join("-", [
      local.kind_listen_address,
      local.kind_localhost_port,
      data.kubernetes_secret.argocd_secret.data.password
    ])
  }

  # https://developer.hashicorp.com/terraform/language/resources/provisioners/local-exec
  provisioner "local-exec" {
    command = "scripts/env-file.sh .env ARGOCD_PASSWORD KIND_LISTEN_ADDRESS KIND_LOCALHOST_PORT"

    working_dir = var.project_dir

    environment = {
      ARGOCD_PASSWORD     = data.kubernetes_secret.argocd_secret.data.password
      KIND_LISTEN_ADDRESS = local.kind_listen_address
      KIND_LOCALHOST_PORT = local.kind_localhost_port
    }
  }
}