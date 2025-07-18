variable "name_prefix" {
  description = "A prefix used to name all resources (e.g., 'cap-iac')."
  type        = string
  default     = "iac-accel" # Shortened to avoid hitting name length limits
}

variable "environment" {
  description = "The deployment environment (e.g., 'dev', 'test', 'prod')."
  type        = string
  default     = "test"
}

variable "project_id" {
  description = "The GCP project ID where resources will be deployed."
  type        = string
}

variable "region" {
  description = "The primary GCP region for resource deployment."
  type        = string
  default     = "us-central1"
}

variable "allow_bucket_force_destroy" {
  description = "A flag to allow destroying GCS buckets even if they contain objects. Should be false in production."
  type        = bool
  default     = true
}

variable "gcs_location" {
  description = "The location for GCS buckets (e.g., a region like 'us-central1' or a multi-region like 'US')."
  type        = string
  default     = "us-central1"
}

variable "gke_node_count" {
  description = "The number of nodes in the GKE cluster node pool."
  type        = number
  default     = 1
}

variable "gke_machine_type" {
  description = "The machine type for the GKE cluster nodes."
  type        = string
  default     = "e2-micro"
}

variable "gke_deletion_protection" {
  description = "A flag to enable deletion protection on the GKE cluster. Should be true in production."
  type        = bool
  default     = false # Set to false for dev/test environments to allow easy recreation.
}
