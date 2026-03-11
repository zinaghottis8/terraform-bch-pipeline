terraform {
  required_version = ">= 1.5.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.30.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.6.0"
    }
  }
}

provider "google" {
  billing_project       = var.bootstrap_billing_project_id
  user_project_override = var.bootstrap_billing_project_id != null && var.bootstrap_billing_project_id != ""
}