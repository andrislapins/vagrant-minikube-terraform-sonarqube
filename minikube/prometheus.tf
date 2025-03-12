
resource "kubernetes_namespace" "prometheus" {
  metadata {
    name = var.prometheus_ns
    labels = {
      name = var.prometheus_ns
    }
  }
}

resource "helm_release" "prometheus" {
  name      = "prometheus"
  namespace = kubernetes_namespace.prometheus.metadata[0].name

  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = "69.2.2"

  wait = true
  values = [
    templatefile("${path.module}/configs/prometheus.tpl.yaml", {
      prometheus_hostname   = var.prometheus_hostname
      grafana_hostname      = var.grafana_hostname
      alertmanager_hostname = var.alertmanager_hostname
    })
  ]
}