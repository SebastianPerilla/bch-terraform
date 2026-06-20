# BCH Terraform

Terraform infrastructure for the Astrafy Data Engineering Take-Home Challenge.

## Overview

This repository provisions all Google Cloud resources required for the Bitcoin Cash analytics pipeline.

The infrastructure includes:

* A dedicated Google Cloud project
* A BigQuery staging dataset
* A BigQuery mart dataset
* A service account for dbt and CI/CD operations
* Required BigQuery IAM permissions
* A service account key generated through Terraform for GitHub Actions authentication

All resources are created and managed through Terraform, ensuring a fully reproducible Infrastructure as Code (IaC) deployment.

---

## Infrastructure Resources

| Resource                                 | Purpose                                         |
| ---------------------------------------- | ----------------------------------------------- |
| Google Cloud Project                     | Dedicated environment for the challenge         |
| BigQuery Staging Dataset (`bch_staging`) | Stores staging models                           |
| BigQuery Mart Dataset (`bch_mart`)       | Stores analytics and data mart models           |
| Service Account (`dbt-ci-runner`)        | Used by dbt and GitHub Actions                  |
| Service Account Key                      | Used by GitHub Actions to authenticate with GCP |
| IAM Roles                                | Grants BigQuery access to the service account   |

---

## Prerequisites

Before deploying the infrastructure, install:

* [Terraform CLI](https://developer.hashicorp.com/terraform/downloads) (>= 1.5.0)
* [Google Cloud SDK (gcloud)](https://cloud.google.com/sdk/docs/install)
* An active Google Cloud Billing Account

Authenticate using Application Default Credentials (ADC):

```bash
gcloud auth application-default login
```

---

## Deployment

### 1. Initialize Terraform

```bash
terraform init
```

### 2. Review the Execution Plan

```bash
terraform plan
```

### 3. Deploy the Infrastructure

```bash
terraform apply
```

### 4. Destroy Resources (Optional)

```bash
terraform destroy
```

---

## Outputs

After a successful deployment, Terraform outputs:

* Google Cloud Project ID
* BigQuery Staging Dataset ID
* BigQuery Mart Dataset ID
* Service Account Email
* Service Account Key (used for GitHub Actions authentication)

The generated service account key can be stored as a GitHub repository secret (`GCP_SA_KEY`) and used by the CI/CD pipeline in the `bch-dbt` repository.

## Automated Credential Management & Key Generation

To support a 100% pure, automated GitOps deployment workflow, this repository is configured to fully manage the lifecycle of the dbt CI/CD cryptographic credentials inside the Terraform state.

### How it Works
Instead of requiring manual key creation through the Google Cloud Console UI or the `gcloud` CLI, Terraform automatically mints, manages, and outputs the service account private key pair using the following architecture:

1. **`google_service_account_key.dbt_ci_key`**: Instructs Google Cloud to securely generate a new private/public key pair for the `dbt-ci-runner` account.
2. **Masked Sensitive Outputs**: The private key payload is stored in `opts.tf` and explicitly designated as `sensitive = true`. This prevents the plaintext credential from ever being accidentally leaked onto your monitor or into public CI/CD build execution logs during a `terraform apply`.

---

###  How to Retrieve the Key for GitHub Secrets

If you are spinning up this infrastructure yourself, you can securely extract the clean, raw JSON payload directly from the encrypted state layer to populate your GitHub Repository secret (`GCP_SERVICE_ACCOUNT_KEY`).

Run the following command in your terminal after deployment:

```bash
terraform output -raw dbt_ci_runner_private_key | base64 --decode > dbt-ci-key.json
```
### Note
Running this command will generate a local file named `dbt-ci-key.json`. 

Once you copy this payload and paste it into your GitHub Secrets tab, permanently delete the local file via:

```bash
`rm -f dbt-ci-key.json`
```

`Never commit this JSON file to version control.`

---

## Assignment Requirements Covered

This repository satisfies the Infrastructure as Code requirements by:

* Creating a new Google Cloud project using Terraform
* Creating BigQuery datasets for staging and data mart tables
* Provisioning a dedicated service account
* Assigning the required BigQuery permissions
* Generating a service account key for CI/CD authentication
* Avoiding manual resource creation outside Terraform

---

## Related Repository
- [`dbt Project`](https://github.com/SebastianPerilla/bch-dbt)

The dbt repository contains:
* Staging and mart models
* GitHub Actions CI workflow
* BigQuery transformations for the Bitcoin Cash dataset

This Terraform repository provides the infrastructure consumed by that project.
