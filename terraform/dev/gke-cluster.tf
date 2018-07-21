# enable the pubsub api for the project
resource "google_project_service" "container" {
  project = "${var.project}"

  # gcloud services list --available
  service = "container.googleapis.com"
}

module "gke_cluster" {
  source             = "../../terraform-modules/gke-cluster"
  name               = "forgotpw-cluster"
  description        = "forgotpw-cluster"
  zone               = "${var.primary_zone}"
  alternate_zone     = "${var.alternate_zone}"
  initial_node_count = "1"
  network            = "${google_compute_network.vpc.name}"
  node_image_type    = "COS"
  node_machine_type  = "n1-standard-1"
  node_disk_size_gb  = "10"
}
