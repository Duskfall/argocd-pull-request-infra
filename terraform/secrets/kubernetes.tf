
# https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/data-sources/kubectl_path_documents
data "kubectl_path_documents" "namespaces" {
  pattern = "${var.project_dir}/manifests/namespaces/*.yaml"
}

# https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/kubectl_manifest
resource "kubectl_manifest" "namespaces" {
  count     = length(data.kubectl_path_documents.namespaces.documents)
  yaml_body = element(data.kubectl_path_documents.namespaces.documents, count.index)
}

data "kubectl_path_documents" "secrets" {
  # https://github.com/GrantBirki/k8s-discord/blob/main/terraform/k8s/modules/containers/frontend/deployment.tf
  pattern = "${var.project_dir}/manifests/secrets/*.yaml"
  vars    = local.kubectl_vars
}

resource "kubectl_manifest" "secrets" {
  # https://github.com/aruna-cande/gcp_infrastructure/blob/main/gke_manifests.tf
  count     = length(data.kubectl_path_documents.secrets.documents)
  yaml_body = element(data.kubectl_path_documents.secrets.documents, count.index)
}

data "kubectl_path_documents" "jobs" {
  pattern = "${var.project_dir}/manifests/jobs/*.yaml"
  vars    = local.kubectl_vars
}

resource "kubectl_manifest" "jobs" {
  count     = length(data.kubectl_path_documents.jobs.documents)
  yaml_body = element(data.kubectl_path_documents.jobs.documents, count.index)
}
