resource "google_compute_network" "vpc_network" {
  name = var.network_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name = "${var.network_name}-sub"
  ip_cidr_range = "10.0.1.0/24"
  region = var.region
  network = google_compute_network.vpc_network.id
}

resource "google_compute_firewall" "web_firewall" {
  name = "${var.network_name}-allow-http-ssh"
  network = google_compute_network.vpc_network.name
  
 allow {
   protocol = "tcp"
   ports = ["22", "80"]
 }
 
 source_ranges = ["0.0.0.0/0"]
}
