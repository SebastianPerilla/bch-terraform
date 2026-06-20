output "new_project_id" {
  value       = google_project.astrafy_project.project_id
  description = "The globally unique ID of the newly created GCP project."
}

output "service_account_email" {
  value       = google_service_account.service_account.email
  description = "The email of the generated service account."
}

output "dbt_ci_runner_private_key" {
  value       = google_service_account_key.dbt_ci_key.private_key
  description = "The Base64 encoded private JSON key for GitHub Actions authentication."
  sensitive   = true
}
