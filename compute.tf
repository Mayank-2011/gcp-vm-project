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

data "google_secret_manager_secret_version" "ssh_key" {
  secret = "jenkins-agent-ssh-pub-key"
  version = "latest"
}

resource "google_compute_instance" "jenkins_agent" {
  name = "jenkins-agent-01"
  machine_type = "e2-micro"
  zone = "us-central1-a"

  allow_stopping_for_update = true
  service_account {
    scopes = ["cloud-platform"]
  }

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      size = 50
    }
  }

  network_interface {
    network = "default"
    access_config {
    }
  }

  metadata = {
    ssh-keys = "jenkins:${data.google_secret_manager_secret_version.ssh_key.secret_data}"
  }

  metadata_startup_script = <<-EOT
    #!bin/bash
    apt-get-update
    apt-get install -y fontconfig openjdk-17-jre git curl unzip
    wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list
    apt-get update
    apt-get install -y terraform
    mkdir -p /home/jenkins-agent/workspace
    chown -R nobody:nogroup /home/jenkins-agent
  EOT

  tags = ["jenkins-agent"]
}
