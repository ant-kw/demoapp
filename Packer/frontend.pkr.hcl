packer {
  required_plugins {
    googlecompute = {
      source = "github.com/hashicorp/googlecompute"
      version = "~> 1"
    }
  }

}

variable "distro" {
  type    = string
  default = "debian-12"
}

variable "GCP_PROJECT_ID" {
  type = string
}

variable "ENV" {
  type    = string
  default = "test"
}

variable "ROLE" {
  type    = string
  default = "packer"
}

locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

source "googlecompute" "image" {
  project_id          = "${var.GCP_PROJECT_ID}"
  zone                = "europe-west1-b"
  subnetwork          = "${var.ENV}"
  source_image_family = "${var.distro}"
  image_family        = "demo-db-${var.distro}"
  image_name          = "demo-db-${var.distro}-${local.timestamp}"
  image_description   = "Demo-Database - Generated ${local.timestamp}"
  machine_type        = "n1-standard-1"
  disk_size           = 20
  on_host_maintenance = "TERMINATE"
  preemptible         = true
  scopes              = ["https://www.googleapis.com/auth/compute.readonly", "https://www.googleapis.com/auth/devstorage.read_only"]
  ssh_username        = "packer"
  tags                = ["packer"]
  metadata            = {
    enable-oslogin    = "false",
    env = "${var.ENV}",
    role = "${var.ROLE}",
  }
  service_account_email = "global@${var.GCP_PROJECT_ID}.iam.gserviceaccount.com"
}

build {
  sources = ["source.googlecompute.image"]

  provisioner "file" {
    source      = "include/debian/apt-gs"
    destination = "/tmp/apt-gs"
  }

  provisioner "file" {
    source      = "include/debian/puppet.key"
    destination = "/tmp/puppet.key"
  }

  provisioner "file" {
    source      = "include/debian/run-puppet"
    destination = "/tmp/run-puppet"
  }

  provisioner "shell" {
    script = "include/debian/frontend-setup.sh"
  }

}
