resource "google_compute_network" "vpc" {
  name                    = "${var.environment}-vpc-network"
  description             = "${var.environment} vpc network"
  project                 = "${var.project}"
  auto_create_subnetworks = "true"
}
