output "function_id" {
  description = "The ID of the Cloud Function."
  value       = google_cloudfunctions2_function.default.id
}

output "function_url" {
  description = "The URL of the Cloud Function."
  value       = google_cloudfunctions2_function.default.service_config[0].uri
}