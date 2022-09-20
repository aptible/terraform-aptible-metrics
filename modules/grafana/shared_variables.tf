# Variables shared with the root module
variable "alert_threshold" {
  description = "The threshold at which alerts are triggered for resource utilization. Default: 0.9 (90%)."
  type        = number
  default     = 0.9
}

variable "alert_trigger_time" {
  description = "The time that it takes for an alert to be triggered with the threshold is crossed. Default: 5m."
  type        = string
  default     = "5m"
}
