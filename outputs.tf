output "project_id" {
  description = "Created GCP project ID."
  value       = google_project.this.project_id
}

output "bigquery_location" {
  description = "BigQuery dataset location."
  value       = var.bigquery_location
}

output "staging_dataset_id" {
  description = "Staging dataset ID."
  value       = google_bigquery_dataset.staging.dataset_id
}

output "mart_dataset_id" {
  description = "Mart dataset ID."
  value       = google_bigquery_dataset.mart.dataset_id
}

output "dbt_service_account_email" {
  description = "Service account email for dbt jobs."
  value       = google_service_account.dbt.email
}

output "dbt_service_account_key_base64" {
  description = "Base64-encoded JSON key. Store in GitHub Secrets and never commit."
  value       = try(google_service_account_key.dbt[0].private_key, null)
  sensitive   = true
}