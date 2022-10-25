output "aptible" {
  description = "All of the outputs from the aptible module."
  value       = module.aptible
  sensitive   = true
}

output "grafana" {
  description = "All of the outputs from the grafana module."
  value       = module.grafana
}
