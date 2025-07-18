variable "location" {
  description = "The GCP region for the BigQuery resources."
  type        = string
}

variable "dataset_id" {
  description = "The ID for the BigQuery dataset."
  type        = string
}

variable "table_id" {
  description = "The ID for the BigQuery table."
  type        = string
}

variable "schema" {
  description = "A JSON string describing the table schema."
  type        = string
}

variable "deletion_protection" {
  description = "If set to true, prevents the table from being accidentally deleted."
  type        = bool
  default     = false
}