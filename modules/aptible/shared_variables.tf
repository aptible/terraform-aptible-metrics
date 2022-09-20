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

variable "grafana_handle" {
  description = "The handle to use for the Grafana App."
  type        = string
  default     = "grafana"
}

variable "grafana_endpoint_domain" {
  description = "The custom domain for the Grafana Endpoint to use. By default the App's default domain will be used. Wildcard domains are not supported."
  type        = string
  default     = null
}

variable "grafana_db_user" {
  description = "The user that Grafana will use to access the PostgreSQL Database. This user is created and granted the necessary permissions on the Database."
  type        = string
  default     = "grafana"
}

variable "grafana_image_tag" {
  description = "The grafana/grafana image tag (i.e. version) that the app will use."
  type        = string
  default     = "latest"
}

variable "grafana_container_count" {
  description = "The number of Grafana App containers to deploy."
  type        = number
  default     = 1
}

variable "grafana_container_size" {
  description = "The container size (in MB) of the Grafana App containers."
  type        = number
  default     = 1024
}

variable "influx_handle" {
  description = "The handle to use for the InfluxDB Database used to store metrics."
  type        = string
  default     = "influx"
}

variable "influx_container_size" {
  description = "The container size (in MB) of the InfluxDB metrics Database container."
  type        = number
  default     = 1024
}

variable "postgres_handle" {
  description = "The handle to use for the PostgreSQL Database used for storing Grafana data."
  type        = string
  default     = "pg-grafana"
}

variable "postgres_container_size" {
  description = "The container size (in MB) of the PostgreSQL Grafana Database container."
  type        = number
  default     = 1024
}
