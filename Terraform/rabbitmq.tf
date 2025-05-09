## Webapp

resource "google_compute_instance_template" "demoapp-rabbitmq" {
  name_prefix  = "demoapp-rabbitmq-template-"
  description  = "Instance Template for demoapp-rabbitmq instances"
  machine_type = var.demoapp-rabbitmq_machine_type
  region       = var.region

  tags = flatten([
    "demoapp-rabbitmq",
    var.env,
  ])

  labels  = {
    "env" = var.env
  }

  disk {
    source_image = var.demoapp-rabbitmq_src_image
    boot         = true
    disk_type    = var.demoapp-rabbitmq_boot_disk_type
    disk_size_gb = var.demoapp-rabbitmq_boot_disk_size

    resource_policies = []

    labels  = {
      "env" = var.env
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.network1.self_link
  }

  metadata = {
    region             = var.region
    env                = var.env
    role               = "rabbitmq"
    startup-script-url = "gs://${google_storage_bucket.bootstrap.name}/${google_storage_bucket_object.rabbit-bootstrap_script.name}"
  }

  service_account {
    email  = google_service_account.global.email
    scopes = ["cloud-platform"]
  }

  scheduling {
    preemptible       = "false"
    automatic_restart = "true"
  }

  lifecycle {
    create_before_destroy = true
  }

}


resource "google_compute_region_instance_group_manager" "demoapp-rabbitmq" {
  name               = "demoapp-rabbitmq"
  base_instance_name = "demoapp-rabbitmq"
  region             = var.region
  target_size        = var.mig_demoapp-rabbitmq_target_size

  version {
    instance_template = google_compute_instance_template.demoapp-rabbitmq.self_link
  }

  auto_healing_policies {
    health_check      = google_compute_health_check.demoapp-rabbitmq.self_link
    initial_delay_sec = 300
  }

  update_policy {
    type                  = "PROACTIVE"
    minimal_action        = "REPLACE"
    max_unavailable_fixed = 0
    max_surge_fixed       = 3
    #    min_ready_sec    = 300
  }

  named_port {
    name = "rabbitmq"
    port = 15672
  }

}

resource "google_compute_health_check" "demoapp-rabbitmq" {
  name = "rabbitmq-health-check"
  timeout_sec        = 5
  check_interval_sec = 5

  tcp_health_check {
    port = "15672"
  }
}

resource "google_compute_backend_service" "demoapp-rabbitmq" {
  name        = "demoapp-rabbitmq-backend-service"
  port_name   = "rabbitmq"
  protocol    = "TCP"
  timeout_sec = "60"
  enable_cdn  = "false"

  backend {
    group           = google_compute_region_instance_group_manager.demoapp-rabbitmq.instance_group
    balancing_mode  = "UTILIZATION"
    capacity_scaler = 1
    max_utilization = 0.9
  }

  health_checks = [google_compute_health_check.demoapp-rabbitmq.self_link]
}

