output "new_project_id" {
  value       = google_project.astrafy_project.project_id
  description = "The globally unique ID of the newly created GCP project."
}

output "service_account_email" {
  value       = google_service_account.service_account.email
  description = "The email of the generated service account."
}
