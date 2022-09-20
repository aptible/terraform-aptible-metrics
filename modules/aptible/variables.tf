variable "metrics_env" {
  # Default to resource_env
  type        = string
  description = "The handle of the environment to send metrics to. This can be one of the drain_environments."
}

variable "drain_environments" {
  type        = list(string)
  description = "The handles of the environments to drain metrics from. By default only the metrics_env will be drained."
  default     = null
}

variable "grafana_endpoint_domain" {
  type        = string
  description = "The custom domain for the Grafana Endpoint to use. By default the App's default domain will be used. Wildcard domains are not supported."
  default     = null
}

variable "grafana_db_user" {
  type        = string
  description = "The user that Grafana will use to access the Database. This user is created and granted the necessary permissions on the Database."
  default     = "grafana"
}

variable "grafana_image_tag" {
  type        = string
  description = "The grafana/grafana image tag (i.e. version) that the app will use."
  default     = "latest"
}
