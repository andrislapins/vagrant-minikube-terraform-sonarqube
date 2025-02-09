
resource "kubernetes_namespace" "metrics" {
  metadata {
    name = var.metrics_ns
    labels = {
      name = var.metrics_ns
    }
  }
}

resource "helm_release" "metrics_server" {
  name      = "metrics-server"
  namespace = kubernetes_namespace.metrics.metadata[0].name

  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"
  version    = "3.12.2"

  wait = true
}