# BigQuery dataset.
resource "google_bigquery_dataset" "default" {
  dataset_id = var.dataset_id
  location   = var.location
}

# BigQuery table in the dataset.
resource "google_bigquery_table" "default" {
  dataset_id = google_bigquery_dataset.default.dataset_id
  table_id   = var.table_id
  schema     = var.schema

  # Set to 'false' for development/testing to allow easy destruction.
  # In production, this should be set to 'true'.
  deletion_protection = var.deletion_protection
}