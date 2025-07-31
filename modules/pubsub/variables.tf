variable "name_prefix" {
  description = "A prefix for resource names to ensure uniqueness."
  type        = string
}

variable "labels" {
  description = "Labels to apply to resources."
  type        = map(string)
  default     = {}
}

variable "topic" {
  description = "The name of the Pub/Sub topic to create a subscription for."
  type        = string
}

variable "bigquery_table_id" {
  description = "The full ID of the BigQuery table for the BQ subscription in the format 'project:dataset.table'."
  type        = string
}