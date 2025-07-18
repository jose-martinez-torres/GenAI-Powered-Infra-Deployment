output "bq_subscription_name" {
  description = "The name of the Pub/Sub subscription that writes to BigQuery."
  value       = google_pubsub_subscription.bq-push-subscription.name
  # Exports the name of the subscription configured to push messages to BigQuery.
}
