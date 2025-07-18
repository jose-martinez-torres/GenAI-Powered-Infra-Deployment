variable "cluster_name" {
  description = "The name for the GKE cluster."
  type        = string
}

variable "project_id" {
  description = "The GCP project ID."
  type        = string
}

variable "location" {
  description = "The GCP region or zone for the GKE cluster."
  type        = string
}

variable "node_count" {
  description = "The number of nodes in the primary node pool."
  type        = number
  default     = 1
}

variable "machine_type" {
  description = "The machine type for the GKE nodes."
  type        = string
}

variable "network" {
  description = "The VPC network to which the GKE cluster is connected."
  type        = string
}

variable "subnetwork" {
  description = "The subnetwork to which the GKE cluster is connected."
  type        = string
}

variable "pods_ip_range_name" {
  description = "The name of the secondary IP range for GKE pods."
  type        = string
}

variable "services_ip_range_name" {
  description = "The name of the secondary IP range for GKE services."
  type        = string
}

variable "deletion_protection" {
  description = "If true, prevents the cluster from being accidentally deleted."
  type        = bool
  default     = false
}