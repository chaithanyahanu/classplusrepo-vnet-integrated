
variable "app_service_plan_name" {
  type        = string
  description = "The name of the App Service Plan."
  default     = "webappplan1"
}

variable "app_service_name" {
  type        = string
  description = "The name of the App Service."
  default     = "webapp987"
}
