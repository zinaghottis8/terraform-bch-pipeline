locals {
  parent_is_org    = var.org_id != null && var.org_id != ""
  parent_is_folder = var.folder_id != null && var.folder_id != ""
}

resource "random_id" "project_suffix" {
  byte_length = 2
}

resource "google_project" "this" {
  name                = var.project_name
  project_id          = "${var.project_id_prefix}-${random_id.project_suffix.hex}"
  billing_account     = var.billing_account_id
  auto_create_network = false

  org_id    = local.parent_is_org ? var.org_id : null
  folder_id = local.parent_is_folder ? var.folder_id : null

  lifecycle {
    precondition {
      condition     = (local.parent_is_org && !local.parent_is_folder) || (!local.parent_is_org && local.parent_is_folder)
      error_message = "Set exactly one of org_id or folder_id."
    }
  }
}

resource "google_project_service" "bigquery" {
  project = google_project.this.project_id
  service = "bigquery.googleapis.com"

  disable_on_destroy = false
}

resource "google_bigquery_dataset" "staging" {
  project    = google_project.this.project_id
  dataset_id = var.staging_dataset_id
  location   = var.bigquery_location

  depends_on = [google_project_service.bigquery]
}

resource "google_bigquery_dataset" "mart" {
  project    = google_project.this.project_id
  dataset_id = var.mart_dataset_id
  location   = var.bigquery_location

  depends_on = [google_project_service.bigquery]
}

resource "google_service_account" "dbt" {
  project      = google_project.this.project_id
  account_id   = var.service_account_id
  display_name = "dbt runner"
}

resource "google_project_iam_member" "dbt_job_user" {
  project = google_project.this.project_id
  role    = "roles/bigquery.jobUser"
  member  = "serviceAccount:${google_service_account.dbt.email}"
}

resource "google_bigquery_dataset_iam_member" "staging_data_editor" {
  project    = google_project.this.project_id
  dataset_id = google_bigquery_dataset.staging.dataset_id
  role       = "roles/bigquery.dataEditor"
  member     = "serviceAccount:${google_service_account.dbt.email}"
}

resource "google_bigquery_dataset_iam_member" "mart_data_editor" {
  project    = google_project.this.project_id
  dataset_id = google_bigquery_dataset.mart.dataset_id
  role       = "roles/bigquery.dataEditor"
  member     = "serviceAccount:${google_service_account.dbt.email}"
}

resource "google_service_account_key" "dbt" {
  count              = var.create_service_account_key ? 1 : 0
  service_account_id = google_service_account.dbt.name
}