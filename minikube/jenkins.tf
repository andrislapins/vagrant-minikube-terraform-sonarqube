
resource "kubernetes_namespace" "jenkins" {
  metadata {
    name = var.jenkins_ns
    labels = {
      name = var.jenkins_ns
    }
  }
}

resource "helm_release" "jenkins" {
  name      = "jenkins"
  namespace = kubernetes_namespace.jenkins.metadata[0].name

  repository = "https://charts.jenkins.io"
  chart      = "jenkins"
  version    = "5.8.10"

  values = [
    templatefile("${path.module}/configs/jenkins.tpl.yaml", {
      jenkins_hostname = var.jenkins_hostname
    })
  ]
}