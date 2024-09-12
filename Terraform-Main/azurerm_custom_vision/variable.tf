
variable "cognitive_account_name" {
  description = "The name of the Custom Vision Cognitive Account for prediction."
  type        = string
  default     = "customtr-Prediction"
}

variable "cognitive_account_name_training" {
  description = "The name of the Custom Vision Cognitive Account for training."
  type        = string
  default     = "customtr"
}
