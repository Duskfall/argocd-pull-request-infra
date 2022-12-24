# https://github.com/tehcyx/terraform-provider-kind
resource "kind_cluster" "cluster" {
  name           = local.cluster_name
  wait_for_ready = true

  kubeconfig_path = pathexpand("~/.kube/config")

  kind_config {
    kind        = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"

    node {
      role = "control-plane"

      # https://github.com/argoproj/argo-helm/blob/17e601148f0325d196e55a77a1b9577c8bbd926d/charts/argo-cd/values.yaml#L1337-L1346
      extra_port_mappings {
        container_port = local.kind_argocd_container_port # 30080
        host_port      = local.kind_localhost_port        # 8443
        listen_address = local.kind_listen_address        # "0.0.0.0"
        protocol       = "TCP"
      }

      dynamic "extra_port_mappings" {
        for_each = local.cluster_ports
        content {
          container_port = extra_port_mappings.value.container # 30000 ... 30005
          host_port      = extra_port_mappings.value.host      # 9000 ... 9005
          listen_address = local.kind_listen_address
          protocol       = "TCP"
        }
      }
    }
  }
}
