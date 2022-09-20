# Variables shared with the root module
variable "metrics_environment" {
  description = "The handle of the environment to send metrics to. This can be one of the drain_environments."
  type        = string
}

variable "drain_environments" {
  description = "The handles of the environments to drain metrics from. By default only the metrics_environment will be drained."
  type        = list(string)
  default     = null
}

variable "grafana_endpoint_domain" {
  description = "The custom domain for the Grafana Endpoint to use. By default the App's default domain will be used. Wildcard domains are not supported."
  type        = string
  default     = null
}

variable "grafana_db_user" {
  description = "The user that Grafana will use to access the Database. This user is created and granted the necessary permissions on the Database."
  type        = string
  default     = "grafana"
}

variable "grafana_image_tag" {
  description = "The grafana/grafana image tag (i.e. version) that the app will use."
  type        = string
  default     = "latest"
}
