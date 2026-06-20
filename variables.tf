variable "project_base_id" {
  type        = string
  description = "The prefix string for your Google Cloud Project ID."
  default     = "bch-astrafy-proj"
}

variable "location" {
  type        = string
  description = "The regional location for BigQuery datasets."
  default     = "US" # Kept as US to ensure cross-query compatibility with public datasets
}

variable "service_account" {
  type        = string
  description = "The ID for the service account that will be created."
  default     = "dbt-ci-runner"
}

variable "billing_account" {
  type        = string
  description = "The ID for your active Google Cloud billing account."
  default     = "015CDB-DB64D0-C0A8FF" 
}

variable "staging_id" {
  type        = string
  description = "The ID for the staging dataset in BigQuery."
  default     = "bch_staging"
}

variable "data_marts_id" {
  type        = string
  description = "The ID for the data_marts dataset in BigQuery."
  default     = "bch_mart"
}
