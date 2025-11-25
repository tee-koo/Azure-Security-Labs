variable "log_analytics_workspace_id" {
  description = "Full resource ID of the Log Analytics workspace with Microsoft Sentinel enabled"
  type        = string
}

variable "threshold" {
  description = "Number of failed sign-ins to trigger an alert (default: 10)"
  type        = number
  default     = 10
}