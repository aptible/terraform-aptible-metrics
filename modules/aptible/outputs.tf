output "aptible_influx_database" {
  description = "The Aptible InfluxDB Database where metrics are stored."
  value       = aptible_database.influx
}

output "influx_database_name" {
  description = "The name of the InfluxDB database where metrics are stored."
  value       = local.influx_database_name
}

output "grafana_endpoint" {
  description = "The Grafana App's public Endpoint. Used to set up DNS records for custom domains."
  value       = aptible_endpoint.grafana_endpoint
}

output "grafana_url" {
  description = "The Grafana App's public URL."
  value       = local.grafana_url
}

output "grafana_auth" {
  description = "An auth string that can be used to access Grafana."
  value       = local.grafana_auth
  sensitive   = true
}

output "grafana_db_user" {
  description = "The PostgreSQL user that Grafana will use to manage its data."
  value       = var.grafana_db_user
}

output "grafana_db_password" {
  description = "The password for the Grafana PostgreSQL user."
  value       = random_password.gf_db_password.result
  sensitive   = true
}

output "grafana_admin_password" {
  description = "The password for the admin Grafana user."
  value       = random_password.gf_admin_password.result
  sensitive   = true
}

output "grafana_data_source" {
  description = "The grafana_data_source corresponding to the InfluxDB Database in the metrics_environment."
  value       = grafana_data_source.influx
  sensitive   = true
}
