variable "grafana_url" {
  description = "The base URL of the Grafana instance to configure."
  type        = string
}

variable "grafana_auth" {
  description = "Credentials to access Grafana in the form of user:password or an API key."
  type        = string
}

variable "influx_data_source_uid" {
  description = "The UID of the InfluxDB data source to use when creating Grafana resources."
}
