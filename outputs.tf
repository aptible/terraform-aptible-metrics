output "aptible" {
  description = "All of the outputs from the aptible submodule."
  value       = module.aptible
  sensitive   = true
}

output "grafana" {
  description = "All of the outputs from the grafana submodule."
  value       = module.grafana
}
