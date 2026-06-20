# Bitcoin Cash Infrastructure - Terraform

This repository provisions the core Google Cloud Platform (GCP) infrastructure for the Bitcoin Cash analytics data pipeline challenge.

## Prerequisites & Dependencies
To run this infrastructure locally, you need the following tools installed:
- [Terraform CLI](https://developer.hashicorp.com/terraform/downloads) (>= 1.5.0)
- [Google Cloud SDK (gcloud CLI)](https://cloud.google.com/sdk/docs/install)

## Infrastructure Resources Provisioned
- 1x Google Cloud Project (`bch-thc-astrafy`)
- 1x BigQuery Staging Dataset (`bch_staging`) located in `US`
- 1x BigQuery Data Mart Dataset (`bch_mart`) located in `US`
- 1x Service Account (`dbt-ci-runner`) with BigQuery Job User and Data Editor roles for CI/CD automation.

## How to Initialize & Apply
1. Authenticate your local shell with GCP Application Default Credentials (ADC):
   ```bash
   gcloud auth application-default login bch-thc-astrafy
   ```

2. Initilize the Backend Infra with the following commands
    ```bash
    terraform init
    ```

3. Preview the Plan
    ```bash
    terraform plan
    ```

4. Apply and Deploy the resources
    ```bash
    terraform apply
    ```
