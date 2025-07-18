output "table_id_full" {
  description = "The full ID of the BigQuery table in the format project:dataset.table."
  value       = "${google_bigquery_table.default.project}:${google_bigquery_table.default.dataset_id}.${google_bigquery_table.default.table_id}"
}