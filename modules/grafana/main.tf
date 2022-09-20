terraform {
  required_providers {
    grafana = {
      source  = "grafana/grafana"
      version = "1.28.2"
    }
  }
}

provider "grafana" {
  url  = var.grafana_url
  auth = var.grafana_auth
}

# Grafana config
variable "grafana_url" {
  type        = string
  description = "The base URL of the Grafana instance to configure."
}

variable "grafana_auth" {
  type        = string
  description = "Credentials to access Grafana in the form of user:password or an API key."
}

variable "influx_data_source_uid" {
  description = "The UID of the InfluxDB data source to use when creating Grafana resources."
}

# Grafana resources
resource "grafana_folder" "aptible_generated" {
  title = "Aptible Generated"
}

resource "grafana_dashboard" "app_metrics" {
  folder    = grafana_folder.aptible_generated.id
  overwrite = true
  config_json = templatefile("${path.module}/templates/dashboard-app.tftpl.json", {
    datasource_uid = var.influx_data_source_uid
  })
}

resource "grafana_dashboard" "database_metrics" {
  folder    = grafana_folder.aptible_generated.id
  overwrite = true
  config_json = templatefile("${path.module}/templates/dashboard-database.tftpl.json", {
    datasource_uid = var.influx_data_source_uid
  })
}

output "grafana_folder" {
  value = grafana_folder.aptible_generated
}
