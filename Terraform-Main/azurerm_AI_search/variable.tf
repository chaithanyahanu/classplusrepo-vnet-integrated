
variable "search_service_name" {
  description = "The name of the Azure Search Service"
  type        = string
  default     = "classplsaisearch"
}

variable "replica_count" {
  description = "Number of replicas for the search service"
  type        = number
  default     = 1
}

variable "partition_count" {
  description = "Number of partitions for the search service"
  type        = number
  default     = 1
}
