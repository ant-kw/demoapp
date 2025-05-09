resource "google_project_service" "project_services" {
  for_each           = var.project_services
  project            = var.gcp_project_id
  service            = each.value
  disable_on_destroy = false
}

resource "google_compute_project_metadata_item" "env" {
  key   = "env"
  value = var.env
}

data "google_project" "project" {}

