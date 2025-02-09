
resource "kubernetes_namespace" "sonarqube" {
  metadata {
    name = var.sonar_ns
    labels = {
      name = var.sonar_ns
    }
  }
}

resource "helm_release" "sonarqube" {
  name      = "sonarqube"
  namespace = kubernetes_namespace.sonarqube.metadata[0].name

  repository = "https://oteemo.github.io/charts"
  chart      = "sonarqube"
  version    = "9.11.0"

  wait   = true
  values = [
    templatefile("${path.module}/configs/sonarqube.tpl.yaml", {
      postgres_url      = local.postgres_url
      sonar_db_name     = var.sonar_db_name
      sonar_db_username = var.sonar_db_username
      sonar_db_password = var.sonar_db_password
      sonar_hostname    = var.sonar_hostname
    })
  ]

  depends_on = [
    helm_release.postgres
  ]
}