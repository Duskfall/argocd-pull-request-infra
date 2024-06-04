locals {
  cluster_name = "cluster-${var.project_name}"

  key_file_pem = "${var.project_dir}/${var.project_name}.pem"

  # /!\ by default, argo-server service is :
  # - type : ClusterIP
  # - http port : 80
  # - https: 443
  # if `server.service.type` is set to "NodePort" now service become :
  # - type : NodePort
  # - http port : 30080
  # - https: 30443
  # https://github.com/argoproj/argo-helm/blob/17e601148f0325d196e55a77a1b9577c8bbd926d/charts/argo-cd/values.yaml#L1337-L1346
  kind_argocd_container_port = 30080
  kind_localhost_port        = 8443
  kind_listen_address        = "0.0.0.0"

  cluster_ports = merge(
    {
      "http" = {
        container = 30000
        host      = 9000
      }
    },
    { for i in range(1, 200) : "pr_${i}" => {
      container = 30010 + i
      host      = 9010 + i
      } if i != 70
    }
  )
}