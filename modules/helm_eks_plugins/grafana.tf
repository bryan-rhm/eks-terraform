resource "helm_release" "prometheus" {
  name            = "prometheus"
  repository      = "https://charts.helm.sh/stable"
  chart           = "prometheus"
  namespace       = var.plugins_namespace
  cleanup_on_fail = true


  set {
    name  = "alertmanager.persistentVolume.enabled"
    value = false
  }
  set {
    name  = "alertmanager.server.enabled"
    value = false
  }
}

resource "helm_release" "grafana" {
  name            = "grafana"
  repository      = "https://grafana.github.io/helm-charts"
  chart           = "grafana"
  namespace       = var.plugins_namespace
  cleanup_on_fail = true

  values = ["${file("${path.module}/values/grafana.yaml")}"]

  set {
    type  = "string"
    name  = "adminPassword"
    value = var.grafana_password
  }

}