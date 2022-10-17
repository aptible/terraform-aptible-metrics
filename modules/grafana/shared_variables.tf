# Variables shared with the root module
variable "folder_title" {
  description = "The title to use for the Grafana folder that will contain all of the managed resources."
  type        = string
  default     = "Aptible Generated"
  nullable    = false
}

variable "alert_threshold" {
  description = "The threshold at which alerts are triggered for resource utilization. Default: 0.9 (90%)."
  type        = number
  default     = 0.9
  nullable    = false
}

variable "alert_trigger_time" {
  description = "The time that it takes for an alert to be triggered with the threshold is crossed. Default: 5m."
  type        = string
  default     = "5m"
  nullable    = false
}

variable "exclude_alerts" {
  description = "If alert management should be excluded."
  type        = bool
  default     = false
  nullable    = false
}
