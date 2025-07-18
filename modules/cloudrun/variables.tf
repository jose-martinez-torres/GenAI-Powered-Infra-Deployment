variable "location" {
  description = "The GCP region where the Cloud Run service will be deployed."
  type        = string
}

variable "service_name" {
  description = "The name of the Cloud Run service."
  type        = string
}

variable "source_bucket_name" {
  description = "The GCS bucket where the function's source code zip is stored."
  type        = string
}

variable "source_object_name" {
  description = "The object name (path) of the function's source code zip in the GCS bucket."
  type        = string
  default     = "sample-cloudrun-source-code"
}

variable "runtime" {
  description = "The runtime in which to run the function."
  type        = string
  default     = "python311"
}

variable "entry_point" {
  description = "The name of the function (within your source code) that will be executed."
  type        = string
  default     = "hello_world"
}