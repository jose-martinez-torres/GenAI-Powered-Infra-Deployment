terraform {
  required_version = ">= 1.0"

  # Configure the GCS backend for storing Terraform state remotely.
  # This is crucial for team collaboration and state locking.
  backend "gcs" {
    bucket = "iac-accel-tfstate"
    prefix = "gcp-sample/terraform.tfstate"
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.0" 
    }
  }
}

# Default Google Cloud provider configuration for the primary region.
provider "google" {
  project = var.project_id
  region  = var.region
}

locals {
  # Create a consistent naming scheme for all resources.
  # Using a local block avoids repetition and ensures consistency.
  # The replace() function is used for BigQuery datasets/tables which don't allow hyphens.
  resource_prefix    = "${var.name_prefix}-${var.environment}"
  bq_resource_prefix = replace(local.resource_prefix, "-", "_")
}

# --- Global / Shared Resources ---

# A global Pub/Sub topic logically associated with the primary region.
# While topics are global, subscriptions to services like BigQuery are regional.
resource "google_pubsub_topic" "primary_topic" {
  name   = "${local.resource_prefix}-primary-topic"
  labels = {
    environment = var.environment
  }
}

# --- Network Resources ---

locals {
  # Suffix the network name to avoid conflicts if other resources use the base prefix.
  network_name = "${local.resource_prefix}-vpc"
}

# A dedicated VPC network for the GKE cluster.
# It's a best practice to not use the 'default' network and to disable auto-creation of subnets.
resource "google_compute_network" "gke_network" {
  name                    = local.network_name
  auto_create_subnetworks = false
}

# A subnetwork for the GKE cluster within the custom VPC.
# The secondary IP ranges are required by GKE for its pods and services.
resource "google_compute_subnetwork" "gke_subnet" {
  name                     = "${local.network_name}-subnet"
  ip_cidr_range            = "10.10.0.0/24"
  region                   = var.region
  network                  = google_compute_network.gke_network.id
  private_ip_google_access = true

  secondary_ip_range {
    range_name    = "gke-pods-range"
    ip_cidr_range = "10.20.0.0/16"
  }
  secondary_ip_range {
    range_name    = "gke-services-range"
    ip_cidr_range = "10.30.0.0/20"
  }
}

 # --- Primary Region Resources ---

# Creates BigQuery resources in the primary region using the new module.
module "bigquery_primary" {
  source     = "./modules/bigquery"
  location   = var.region
  dataset_id = "${local.bq_resource_prefix}_primary_dataset"
  table_id   = "${local.bq_resource_prefix}_primary_table"
  schema     = file("${path.module}/schemas/bq_pubsub_schema.json")
}

# Creates a Pub/Sub subscription to push messages to BigQuery
# for the primary region using a reusable module.
module "pub_sub_primary" {
  source      = "./modules/pubsub"
  name_prefix = local.resource_prefix
  labels      = { environment = var.environment, region = var.region }
  topic       = google_pubsub_topic.primary_topic.id
  bigquery_table_id = module.bigquery_primary.table_id_full
}

# Creates a GKE cluster in the primary region.
module "gke_primary" {
  source       = "./modules/GKE"
  project_id   = var.project_id
  cluster_name = "${local.resource_prefix}-cluster"
  location     = var.region
  node_count   = var.gke_node_count
  machine_type = var.gke_machine_type
  network      = google_compute_network.gke_network.id
  subnetwork   = google_compute_subnetwork.gke_subnet.id
  pods_ip_range_name     = "gke-pods-range"
  services_ip_range_name = "gke-services-range"
  deletion_protection    = var.gke_deletion_protection
}

# GCS bucket for data that is accessed infrequently (e.g., monthly).
resource "google_storage_bucket" "nearline" {
  name          = "${local.resource_prefix}-nearline"
  location      = var.gcs_location
  storage_class = "NEARLINE"
  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }

  # The following setting is useful for demos and testing, as it allows the bucket
  # to be destroyed even if it contains objects.
  # WARNING: Do not use force_destroy = true in production environments.
  force_destroy = var.allow_bucket_force_destroy
}

# GCS bucket for long-term archival data that is rarely accessed.
resource "google_storage_bucket" "coldline" {
  name          = "${local.resource_prefix}-coldline"
  location      = var.gcs_location
  storage_class = "COLDLINE"
  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }

  # WARNING: Do not use force_destroy = true in production environments.
  force_destroy = var.allow_bucket_force_destroy
}

# --- Serverless Resources ---

# Creates a Cloud Function (2nd Gen) which runs on Cloud Run.
module "cloud_run_function" {
  source             = "./modules/cloudrun"
  service_name       = "${local.resource_prefix}-function"
  location           = var.region
  source_bucket_name = var.function_source_bucket_name
  source_object_name = "sample-cloudrun-source-code.zip"
  # The runtime and entry_point are using the defaults from the module.
}


# --- Outputs ---

output "pubsub_primary_topic_name" {
  description = "The name of the primary Pub/Sub topic."
  value       = google_pubsub_topic.primary_topic.name
}

output "nearline_bucket_url" {
  description = "The URL of the Nearline storage bucket."
  value       = google_storage_bucket.nearline.url
}

output "coldline_bucket_url" {
  description = "The URL of the Coldline storage bucket."
  value       = google_storage_bucket.coldline.url
}

output "gke_cluster_name" {
  description = "The name of the primary GKE cluster."
  value       = module.gke_primary.cluster_name
}

output "cloud_function_url" {
  description = "The URL of the Cloud Function."
  value       = module.cloud_run_function.function_url
}
