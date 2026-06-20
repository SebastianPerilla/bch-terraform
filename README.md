# BCH Terraform

Terraform infrastructure for the Data Engineering Take-Home Challenge.

## Overview

This repository provisions the Google Cloud resources required for the Bitcoin Cash analytics pipeline.

The infrastructure includes:

* A new Google Cloud project
* A BigQuery staging dataset
* A BigQuery mart dataset
* A service account for dbt
* Required BigQuery IAM permissions

All resources are created through Terraform to satisfy the assignment requirement of using Infrastructure as Code (IaC). 

---

## Resources Created

| Resource                 | Purpose                                       |
| ------------------------ | --------------------------------------------- |
| Google Cloud Project     | Dedicated environment for the challenge       |
| BigQuery Staging Dataset | Stores staging models                         |
| BigQuery Mart Dataset    | Stores analytics/data mart models             |
| Service Account          | Used by dbt and GitHub Actions                |
| IAM Roles                | Grants BigQuery access to the service account |

---

## Prerequisites

* Terraform >= 1.10
* Google Cloud SDK (`gcloud`)
* An active Google Cloud Billing Account

Authenticate before running Terraform:

```bash
gcloud auth application-default login
```

---

## Deployment

Initialize Terraform:

```bash
terraform init
```

Review the execution plan:

```bash
terraform plan
```

Deploy the infrastructure:

```bash
terraform apply
```

Destroy all resources:

```bash
terraform destroy
```

---

## Outputs

After deployment, Terraform provides:

* Google Cloud Project ID
* Service Account Email
* BigQuery Dataset IDs

These values are used by the `bch-dbt` repository and GitHub Actions workflow.

---

## Assignment Requirements Covered

* Create a new Google Cloud project using Terraform
* Create BigQuery datasets for staging and mart tables
* Provision a service account
* Assign required BigQuery permissions
* No manual resource creation outside Terraform

---

## Related Repository

**dbt Project:** [`bch-dbt`](https://github.com/SebastianPerilla/bch-dbt)

Contains the dbt models and GitHub Actions workflow that use the infrastructure provisioned by this repository.

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
