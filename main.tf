terraform {
  required_version = ">= 1.10.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "google" {
  region = "europe-southwest1" # Madrid, Spain regional endpoint setup
}

# Generate a random suffix to guarantee global project ID uniqueness 
resource "random_id" "project_suffix" {
  byte_length = 4
}

# Create the brand-new Google Cloud Project from scratch
resource "google_project" "astrafy_project" {
  name            = "BCH Analytics Production"
  project_id      = "${var.project_base_id}-${random_id.project_suffix.hex}"
  billing_account = var.billing_account
  deletion_policy = "DELETE"
}

# Enable Required APIs
resource "google_project_service" "billing_api" {
  project            = google_project.astrafy_project.project_id
  service            = "cloudbilling.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "bigquery" {
  project            = google_project.astrafy_project.project_id
  service            = "bigquery.googleapis.com"
  disable_on_destroy = false
}

# Create BigQuery Datasets
resource "google_bigquery_dataset" "staging" {
  project       = google_project.astrafy_project.project_id
  dataset_id    = var.staging_id
  friendly_name = "Bitcoin Cash Staging"
  location      = var.location
  depends_on    = [google_project_service.bigquery]
}

resource "google_bigquery_dataset" "data_marts" {
  project       = google_project.astrafy_project.project_id
  dataset_id    = var.data_marts_id
  friendly_name = "Bitcoin Cash Data Marts"
  location      = var.location
  depends_on    = [google_project_service.bigquery]
}

# Create a Service Account
resource "google_service_account" "service_account" {
  project      = google_project.astrafy_project.project_id
  account_id   = var.service_account
  display_name = "BigQuery Service Account"
}

# Automatically generate the private JSON credential key
resource "google_service_account_key" "dbt_ci_key" {
  service_account_id = google_service_account.service_account.name
  private_key_type   = "TYPE_GOOGLE_CREDENTIALS_FILE"
}

# ============================================================================
# IAM PERMISSIONS (LEAST PRIVILEGE LAYER)
# ============================================================================

# 1. Project-wide permission: ONLY allow the SA to execute query jobs
resource "google_project_iam_member" "job_user" {
  project = google_project.astrafy_project.project_id
  role    = "roles/bigquery.jobUser"
  member  = "serviceAccount:${google_service_account.service_account.email}"
}

# 2. Dataset-specific permission: Only allow Data Editing inside the Staging dataset
resource "google_bigquery_dataset_iam_member" "staging_editor" {
  project    = google_project.astrafy_project.project_id
  dataset_id = google_bigquery_dataset.staging.dataset_id
  role       = "roles/bigquery.dataEditor"
  member     = "serviceAccount:${google_service_account.service_account.email}"
}

# 3. Dataset-specific permission: Only allow Data Editing inside the Marts dataset
resource "google_bigquery_dataset_iam_member" "marts_editor" {
  project    = google_project.astrafy_project.project_id
  dataset_id = google_bigquery_dataset.data_marts.dataset_id
  role       = "roles/bigquery.dataEditor"
  member     = "serviceAccount:${google_service_account.service_account.email}"
}
