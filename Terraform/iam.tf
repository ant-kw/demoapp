resource "google_service_account" "global" {
  account_id   = "global"
  display_name = "Global Service Account"
}

resource "google_project_iam_custom_role" "global" {
  role_id     = "global"
  title       = "global"
  description = "Global role for GCE instances"

  permissions = [
    "compute.instances.list",
    "compute.zones.list",
    "compute.instances.get",
  ]
}

resource "google_project_iam_member" "global-role" {
  project = var.gcp_project_id
  role    = google_project_iam_custom_role.global.id
  member  = "serviceAccount:${google_service_account.global.email}"
}

resource "google_project_iam_member" "global-logging" {
  project = var.gcp_project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.global.email}"
}

resource "google_project_iam_member" "global-metrics" {
  project = var.gcp_project_id
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.global.email}"
}

resource "google_storage_bucket_iam_member" "global-boot-scripts" {
  bucket = google_storage_bucket.bootstrap.name
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.global.email}"
}

