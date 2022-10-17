module "aptible" {
  source                     = "./modules/aptible"
  metrics_environment        = var.metrics_environment
  drain_environments         = var.drain_environments
  grafana_handle             = var.grafana_handle
  grafana_endpoint_domain    = var.grafana_endpoint_domain
  grafana_db_user            = var.grafana_db_user
  grafana_image_tag          = var.grafana_image_tag
  grafana_container_count    = var.grafana_container_count
  grafana_container_size     = var.grafana_container_size
  grafana_container_profile  = var.grafana_container_profile
  influx_handle              = var.influx_handle
  influx_container_size      = var.influx_container_size
  influx_container_profile   = var.influx_container_profile
  postgres_handle            = var.postgres_handle
  postgres_container_size    = var.postgres_container_size
  postgres_container_profile = var.postgres_container_profile
}

module "grafana" {
  source                 = "./modules/grafana"
  grafana_url            = module.aptible.grafana_url
  grafana_auth           = module.aptible.grafana_auth
  influx_data_source_uid = module.aptible.grafana_data_source.uid
  folder_title           = var.folder_title
  alert_threshold        = var.alert_threshold
  alert_trigger_time     = var.alert_trigger_time
  exclude_alerts         = var.exclude_alerts
}
