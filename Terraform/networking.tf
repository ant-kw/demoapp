resource "google_compute_network" "network" {
  name                    = "${var.env}-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "network1" {
  name                     = "${var.env}"
  ip_cidr_range            = var.network_ip_range
  network                  = google_compute_network.network.name
  region                   = var.region
  private_ip_google_access = true

}

resource "google_compute_address" "nat-ip" {
  name   = "nat-external-ip-${count.index}"
  region = var.region
  count  = 1
  lifecycle {
    prevent_destroy = false
  }
}

resource "google_compute_router" "router" {
  name    = "nat-router"
  region  = var.region
  network = google_compute_network.network.id
}

resource "google_compute_router_nat" "cloud-nat" {
  name                               = "${var.env}-cloud-nat"
  router                             = google_compute_router.router.name
  nat_ip_allocate_option             = "MANUAL_ONLY"
  nat_ips                            = google_compute_address.nat-ip.*.self_link
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  subnetwork {
    name                    = google_compute_subnetwork.network1.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }

}

resource "google_compute_firewall" "healthcheck" {
  name        = "google-healthcheck"
  description = "Google HeathChecks"
  network     = google_compute_network.network.id

  allow {
    protocol = "tcp"
    ports = [
      "80",
      "8080"
    ]
  }
  allow {
    protocol = "icmp"
  }

  source_ranges = [
    "35.191.0.0/16",
    "130.211.0.0/22",
    "209.85.152.0/22",
    "209.85.204.0/22"
  ]

  target_tags = [
    "demoapp",
  ]
}

resource "google_compute_firewall" "internal-ssh" {
  name        = "ssh-internal"
  description = "Allow internal SSH from bastion"
  network     = google_compute_network.network.id

  allow {
    protocol = "tcp"
    ports = [
      "22"
    ]
  }
  allow {
    protocol = "icmp"
  }

  source_tags = [
    "bastion"
  ]
}


resource "google_compute_global_address" "private_ip_address" {
  name          = "private-ip-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.network.id
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.network.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}

resource "google_dns_managed_zone" "internal" {
  name        = "demoapp-internal"
  dns_name    = "demoapp-internal."
  description = "Project internal DNS"

  labels = {
    envname   = var.env
  }

  visibility = "private"

  private_visibility_config {
    networks {
      network_url = google_compute_network.network.self_link
    }
  }
}
