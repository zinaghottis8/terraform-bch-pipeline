variable "billing_account_id" {
  description = "Billing account ID."
  type        = string
}

variable "org_id" {
  description = "Organization ID."
  type        = string
  default     = null
}

variable "folder_id" {
  description = "Folder ID, numbers only."
  type        = string
  default     = null
}

variable "project_id_prefix" {
  description = "Prefix for the GCP project ID."
  type        = string
  default     = "astrafy-bch"
}

variable "project_name" {
  description = "GCP project name."
  type        = string
  default     = "AstraFy BCH pipeline"
}

variable "bigquery_location" {
  description = "BigQuery location."
  type        = string
  default     = "EU"
}

variable "staging_dataset_id" {
  description = "Staging dataset ID."
  type        = string
  default     = "bch_staging"
}

variable "mart_dataset_id" {
  description = "Mart dataset ID."
  type        = string
  default     = "bch_mart"
}

variable "service_account_id" {
  description = "Service account ID."
  type        = string
  default     = "dbt-runner"
}

variable "create_service_account_key" {
  description = "Whether to create a service account key."
  type        = bool
  default     = true
}

variable "bootstrap_billing_project_id" {
  description = "Optional billing-enabled project for bootstrap operations."
  type        = string
  default     = null
}