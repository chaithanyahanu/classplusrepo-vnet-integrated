variable "translator_name" {
  description = "The name of the Translator cognitive service"
  type        = string
  default     = "clstranslator456"
}

variable "sku_name" {
  description = "The SKU of the Translator cognitive service (e.g. F0 for free or S1 for standard)"
  type        = string
  default     = "S1"
}

