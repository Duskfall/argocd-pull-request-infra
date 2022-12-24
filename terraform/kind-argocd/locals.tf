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

  cluster_ports = {
    http : {
      container : 30000
      host : 9000
    },

    pr_1 : {
      container : 30001
      host : 9001
    },

    pr_2 : {
      container : 30002
      host : 9002
    },

    pr_3 : {
      container : 30003
      host : 9003
    },

    pr_4 : {
      container : 30004
      host : 9004
    }

    pr_5 : {
      container : 30005
      host : 9005
    }

    pr_6 : {
      container : 30006
      host : 9006
    }

    pr_7 : {
      container : 30007
      host : 9007
    }
  }
}