module "aptible" {
  source                  = "./modules/aptible"
  drain_environments      = var.drain_environments
  metrics_environment     = var.metrics_environment
  grafana_endpoint_domain = var.grafana_endpoint_domain
  grafana_db_user         = var.grafana_db_user
  grafana_image_tag       = var.grafana_image_tag
}

module "grafana" {
  source                 = "./modules/grafana"
  grafana_url            = module.aptible.grafana_url
  grafana_auth           = module.aptible.grafana_auth
  influx_data_source_uid = module.aptible.grafana_data_source.uid
  alert_threshold        = var.alert_threshold
  alert_trigger_time     = var.alert_trigger_time
}

output "aptible_resources" {
  value     = module.aptible
  sensitive = true
}

output "grafana_resources" {
  value = module.grafana
}
