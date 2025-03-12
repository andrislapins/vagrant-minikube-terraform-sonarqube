
locals {
  postgres_url = "${helm_release.postgres.name}-postgresql.${kubernetes_namespace.postgres.metadata[0].name}.svc.cluster.local"
}

resource "kubernetes_namespace" "postgres" {
  metadata {
    name = var.postgres_ns
    labels = {
      name = var.postgres_ns
    }
  }
}

# NOTE: When redeploying Postgres Helm chart, don't forget to delete PVCs too
# or the whole namespace, otherwise the old passwords persist:
# https://github.com/bitnami/charts/issues/15975
resource "helm_release" "postgres" {
  name      = "postgres"
  namespace = kubernetes_namespace.postgres.metadata[0].name

  repository = "oci://registry-1.docker.io/bitnamicharts"
  chart      = "postgresql"
  version    = "16.4.4"

  wait = true
  values = [
    templatefile("${path.module}/configs/postgres.tpl.yaml", {
      postgres_password = var.postgres_password
      sonar_db_name     = var.sonar_db_name
      sonar_db_username = var.sonar_db_username
      sonar_db_password = var.sonar_db_password
    })
  ]
}