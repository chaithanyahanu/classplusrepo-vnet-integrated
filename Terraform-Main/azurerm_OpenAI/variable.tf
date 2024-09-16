variable "openai_account_name" {
  description = "Name of the Azure OpenAI account."
  type        = string
  default     = ""
}

variable "sku_name" {
  description = "The SKU name of the OpenAI account (e.g., S0)."
  type        = string
  default     = ""
}
