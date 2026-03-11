## terraform-bch-pipeline

Terraform configuration for provisioning the Google Cloud infrastructure required by the BCH analytics pipeline.
This repository creates, through a single Terraform apply, the Google Cloud resources needed to support a dbt-based pipeline in BigQuery. It provisions an isolated GCP project, enables the required APIs, creates the staging and mart datasets, and configures a dedicated service account for dbt execution. Optional service account key generation is also supported for CI/CD use cases.
Because the infrastructure is defined entirely in Terraform, it is reproducible, version-controlled, and easy to create or destroy as needed.

## Architecture Decisions
    Dedicated GCP project : The BCH pipeline is deployed into its own GCP project to isolate billing, IAM, and resources from other environments.
    Separate bch_staging and bch_mart datasets: This follows a standard analytics pattern: bch_staging holds raw or lightly transformed data, while bch_mart contains curated models intended for downstream reporting and analysis.
    Dedicated dbt service account: dbt runs under a dedicated service account rather than a personal identity. This keeps permissions explicit and limited to the pipeline’s operational needs.
    Random suffix for the project ID: Since GCP project IDs must be globally unique, a random suffix makes the configuration reusable across repeated test runs and parallel environments.
    Optional service account key generation: Key creation is controlled through create_service_account_key, allowing the same configuration to support both CI systems that require a key and setups that prefer keyless authentication.

## Resources Created
    After a successful terraform apply, the configuration provisions:
        - A GCP project
           configurable project name
           project ID in the form astrafy-bch-<random_hex>
           billing linked to the specified billing account
        - BigQuery API activation
            bigquery.googleapis.com
        - Two BigQuery datasets
            bch_staging and bch_mart 
        - A dbt service account
            Account ID defaults to dbt-runner
        - IAM permissions for dbt
            Project-level roles/bigquery.jobUser
            Dataset-level roles/bigquery.dataEditor on: bch_staging , bch_mart. 
        - An optional service account key

## Repository Structure
    - provider.tf : Defines Terraform and provider requirements and configures the Google provider.

    - main.tf Contains the core infrastructure, including the GCP project, API enablement, datasets, service account, IAM bindings, and optional key creation.

    - variables.tf: Declares and documents input variables used by the configuration. 

    - outputs.tf : Exposes the main deployment outputs.
    
    - terraform.tfvars.example :Provides a sample variable file for local configuration.

## Prerequisites
    Terraform >= 1.5.0
    Google Cloud CLI (gcloud)
    A Google Cloud account with:
        access to a valid billing account
        sufficient permissions to create projects under an organization or folder
    Authenticated local Google Cloud credentials so Terraform can interact with GCP through the Google provider


## Deployment
1. Authenticate with Google Cloud
```bash
gcloud auth login
gcloud auth application-default login
```

2. Clone the repository
```bash
git clone <this-repo-url>
cd terraform-bch-pipeline
```

3. Create a `terraform.tfvars` file
```bash
cp terraform.tfvars.example terraform.tfvars
```
Update terraform.tfvars with values for your environment. At a minimum, you must provide:
    * billing_account_id
    * exactly one of org_id or folder_id
You may also customize the project name, project ID prefix, BigQuery location, dataset names, service account ID, and service account key creation behavior.

4. Initialize Terraform
```bash
terraform init
```

5. Review the plan
```bash
terraform plan
```

6. Apply the configuration
```bash
terraform apply
```
After deployment, Terraform returns the main outputs defined in outputs.tf, including:
    project_id : The ID of the provisioned GCP project.
    dbt_service_account_email : The email address of the dbt service account.
    dbt_service_account_key_base64 when key creation is enabled : A sensitive, base64-encoded JSON service account key.
