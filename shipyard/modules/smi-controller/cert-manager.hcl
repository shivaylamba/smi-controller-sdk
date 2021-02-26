k8s_config "cert-manager" {
  cluster = "k8s_cluster.dc1"
  
  paths = [
    "./cert-manager.crds.yaml",
  ]

  wait_until_ready = true
}

helm "cert-manager" {
  depends_on = ["k8s_config.cert-manager"]

  create_namespace = true
  namespace = "smi"
  cluster = "k8s_cluster.dc1"

  chart = "github.com/jetstack/cert-manager?ref=v1.2.0/deploy/charts//cert-manager"

  values = "./cert-manager-helm-values.yaml" 
 
  health_check {
    timeout = "60s"
    pods = ["app=webhook"]
  }
}

helm "smi-controler" {
  depends_on = ["helm.cert-manager"]

  cluster = "k8s_cluster.dc1"
  namespace = "smi"

  chart = "../../../helm/smi-controller"

  values_string = {
    "controller.enabled" = "false"
    "webhook.service" = "smi-webhook"
    "webhook.namespace" = "shipyard"
    "webhook.additionalDNSNames.0" = "smi-webhook.shipyard.svc"
  }
}
