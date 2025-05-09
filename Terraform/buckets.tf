resource "google_storage_bucket" "bootstrap" {
  name     = "${var.gcp_project_id}-bootstrap"
  location = var.bucket_location
  labels   = {
    "env"  = var.env
  }
}

resource "google_storage_bucket_object" "bootstrap_script" {
  bucket = google_storage_bucket.bootstrap.name
  name   = "bootstrap.sh"
  source = "include/bootstrap.sh"
}

resource "google_storage_bucket_object" "rabbit-bootstrap_script" {
  bucket = google_storage_bucket.bootstrap.name
  name   = "rabbit-bootstrap.sh"
  source = "include/rabbit-bootstrap.sh"
}

resource "google_storage_bucket_iam_member" "bootstrap-global-read" {
  bucket = google_storage_bucket.bootstrap.name
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.global.email}"
}


resource "google_storage_bucket" "repo-bucket" {
  name     = "demoapp-${var.env}-repo"
  location = var.bucket_location
  labels   = {
    "env"  = var.env
  }
}

resource "google_storage_bucket_iam_member" "repo-global-read" {
  bucket = google_storage_bucket.repo-bucket.name
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.global.email}"
}

## jenkins test - write
resource "google_storage_bucket_iam_member" "jenkins-test-read" {
  bucket = google_storage_bucket.repo-bucket.name
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${data.google_project.project.number}-compute@developer.gserviceaccount.com"
}
resource "google_storage_bucket_iam_member" "jenkins-test-write" {
  bucket = google_storage_bucket.repo-bucket.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${data.google_project.project.number}-compute@developer.gserviceaccount.com"
}

