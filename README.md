# terraform-bch-pipeline

Terraform configuration for Part 2 of the Analytics / Data Engineer take-home.

## What this repo does

This repository provisions the infrastructure needed for the BCH pipeline:

- a new Google Cloud project
- the BigQuery API
- two BigQuery datasets:
  - `bch_staging`
  - `bch_mart`
- one service account for dbt runs
- the required BigQuery permissions for that service account

## Files

- `provider.tf` → Terraform and provider configuration
- `main.tf` → GCP project, BigQuery datasets, service account, IAM
- `variables.tf` → input variables
- `outputs.tf` → useful outputs after apply
- `terraform.tfvars` → variable values for deployment

## Requirements

- Terraform >= 1.5.0
- Google Cloud CLI
- authenticated Google Cloud account
- billing account and organization or folder access

## How to use

### 1. Authenticate with Google Cloud

```bash
gcloud auth login
gcloud auth application-default login