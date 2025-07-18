# Creates a GKE cluster.
# Best practice is to remove the default node pool and create a managed one separately.
resource "google_container_cluster" "primary" {
  project                  = var.project_id
  name                     = var.cluster_name
  location                 = var.location
  remove_default_node_pool = true
  initial_node_count       = 1 # Required, but the default pool will be removed.
  network                  = var.network
  subnetwork               = var.subnetwork

  ip_allocation_policy {
    cluster_secondary_range_name  = var.pods_ip_range_name
    services_secondary_range_name = var.services_ip_range_name
  }

  deletion_protection = var.deletion_protection
}

# Creates a managed node pool for the GKE cluster.
resource "google_container_node_pool" "primary_nodes" {
  project    = var.project_id
  name       = "${var.cluster_name}-nodes"
  location   = var.location
  cluster    = google_container_cluster.primary.name
  node_count = var.node_count

  node_config {
    machine_type = var.machine_type
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}