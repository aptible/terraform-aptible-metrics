module "aptible_metrics" {
  # Use the git or terraform registry source in your own templates
  # source = "git::git@github.com:aptible/terraform-aptible-metrics.git?ref=v1.0.0"
  source              = "../../"
  metrics_environment = "my-env"
}

output "grafana_url" {
  value     = module.aptible_metrics.aptible.grafana_url
  sensitive = true
}

output "grafana_auth" {
  value     = module.aptible_metrics.aptible.grafana_auth
  sensitive = true
}
