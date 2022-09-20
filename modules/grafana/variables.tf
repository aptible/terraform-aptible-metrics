variable "alert_threshold" {
  type        = number
  description = "The threshold at which alerts are triggered for resource utilization. Default: 0.9 (90%)."
  default     = 0.9
}

variable "alert_trigger_time" {
  type        = string
  description = "The time that it takes for an alert to be triggered with the threshold is crossed. Default: 5m."
  default     = "5m"
}
