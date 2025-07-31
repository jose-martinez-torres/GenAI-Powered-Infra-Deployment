# Creates a subscription that directly pushes messages from the topic to a BigQuery table.
# An explicit dependency is set on the IAM binding to ensure permissions are in place.
resource "google_pubsub_subscription" "bq-push-subscription" {
  name       = "${var.name_prefix}-bq-subscription"
  topic      = var.topic
  depends_on = [google_bigquery_table_iam_member.pubsub_to_bq_writer]

  bigquery_config {
    table = var.bigquery_table_id

    # Writes Pub/Sub message metadata (e.g., publish_time) to corresponding
    # columns in the BigQuery table. This requires the table schema to have
    # matching fields.
    write_metadata = true

    # Prevents delivery failures if the message contains fields that do not
    # exist in the BigQuery table schema. This improves resilience to schema drift.
    drop_unknown_fields = true
  }
}

locals {
  # The bigquery_table_id is in the format "project:dataset.table".
  # We use regex to extract the parts for the IAM binding.
  bq_table_details = regex("([^:]+):([^.]+)\\.(.+)", var.bigquery_table_id)
}

# Retrieves the project number for the current project, which is required for
# constructing the service account email for IAM bindings.
data "google_project" "project" {}

# Grants the Google-managed Pub/Sub service account the 'roles/bigquery.dataEditor' role,
# allowing it to write data to the specified BigQuery table for the BQ subscription.
resource "google_bigquery_table_iam_member" "pubsub_to_bq_writer" {
  project    = local.bq_table_details[0]
  dataset_id = local.bq_table_details[1]
  table_id   = local.bq_table_details[2]
  role       = "roles/bigquery.dataInserter"
  member     = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-pubsub.iam.gserviceaccount.com"
}
