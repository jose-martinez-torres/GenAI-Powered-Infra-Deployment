resource "google_cloudfunctions2_function" "default" {
  name     = var.function_name
  location = var.location

  build_config {
    runtime     = var.runtime
    entry_point = var.entry_point
    source {
      storage_source {
        bucket = var.source_bucket_name
        object = var.source_object_name
      }
    }
  }

  service_config {
    max_instance_count               = 1
    available_memory                 = "256Mi"
    timeout_seconds                  = 60
    all_traffic_on_latest_revision = true
  }
}
