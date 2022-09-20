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

# Grafana resources
resource "grafana_folder" "aptible_generated" {
  title = var.folder_title
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
