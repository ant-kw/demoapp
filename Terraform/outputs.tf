
output "NAT_IPS" {
  value = google_compute_address.nat-ip.*.address
}

