
resource "helm_release" "influxdb" {
  name            = "influxdb"
  chart           = "${path.module}/charts/influxdb/"
  cleanup_on_fail = true
  namespace       = var.plugins_namespace

  set {
    name  = "INFLUXDB_DB"
    value = "fluentbit"
  }

  set {
    name  = "setDefaultUser.enabled"
    value = true
  }

  set {
    name  = "setDefaultUser.username"
    value = "admin"
  }

  set {
    name  = "setDefaultUser.password"
    value = "password"
  }
}

resource "helm_release" "fluent-bit" {
  name            = "fluent-bit"
  chart           = "${path.module}/charts/fluent-bit/"
  cleanup_on_fail = true
  values          = ["${file("${path.module}/values/fluent-bit.yaml")}"]
  namespace       = var.plugins_namespace
  depends_on      = [helm_release.influxdb]
}
