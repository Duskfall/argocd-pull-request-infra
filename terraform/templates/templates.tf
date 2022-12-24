resource "local_file" "template_argocd" {
  for_each = fileset("${var.project_dir}/argocd/.tmpl/", "**")
  content  = templatefile("${var.project_dir}/argocd/.tmpl/${each.value}", local.template_vars)
  filename = pathexpand("${var.project_dir}/argocd/${each.value}")
}

resource "local_file" "template_overlays_master" {
  content  = templatefile("${var.project_dir}/manifests/overlays/.tmpl/kustomization.yaml", local.template_vars)
  filename = pathexpand("${var.project_dir}/manifests/overlays/master/kustomization.yaml")
}