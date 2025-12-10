resource "google_compute_instance" "vm_instance" {
  name = "free-tier-web-server"
  machine_type = "e2-micro"
  zone = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }
  
  network_interface {
    subnetwork = module.networking.subnet_id
    access_config {
    }
  }
  
  metadata_startup_script = <<-EOT
    #!bin/bash
    apt-get update
    apt-get install -y nginx
    echo "<h1>Hello from Terraform!</h1>" > /var/www/html/index.html
  EOT
}
