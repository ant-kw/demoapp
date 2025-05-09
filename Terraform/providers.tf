provider "google" {
  region                = var.region
  project               = var.gcp_project_id
  billing_project       = var.gcp_project_id
  user_project_override = true
}

provider "google-beta" {
  region  = var.region
  project = var.gcp_project_id
}


terraform {
  required_version = ">= 1.7.5"

  backend "gcs" {
    bucket = "demoapp-tf-state"
    prefix = ""
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.25.0"
    }

    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 5.25.0"
    }

    random = {
      source = "hashicorp/random"
      version = "~> 3.7.2"
    }

  }

}
