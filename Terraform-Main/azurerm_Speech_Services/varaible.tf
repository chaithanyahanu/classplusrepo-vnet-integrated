variable "speechservice" {
  description = "The name of the speechservice cognitive service"
  type        = string
  default     = "classplusspeechservice"
}

variable "sku_name" {
  description = "The SKU of the sppechservice cognitive service (e.g. F0 for free or S0 for standard)"
  type        = string
  default     = "S0"
}
