# 'provider' block: This block tells Terraform which cloud service provider to use. Configuration details can vary depending on the provider.
# Specify the Hetzner Cloud provider for Terraform.
terraform {
# 'provider' block: This block tells Terraform which cloud service provider to use. Configuration details can vary depending on the provider.
  required_providers {
# Configuration for 'hcloud': This line sets the value for the 'hcloud' setting.
    hcloud = {
# Configuration for 'source': This line sets the value for the 'source' setting.
      source = "hetznercloud/hcloud"
    }
  }
}

# Connect to Hetzner Cloud using the provided API token.
# 'provider' block: This block tells Terraform which cloud service provider to use. Configuration details can vary depending on the provider.
provider "hcloud" {
# Configuration for 'token': This line sets the value for the 'token' setting.
  token = var.api_token     # Authenticate with the given API token.
}

# Input variables for user customization.
# 'variable' block for 'ssh_key': This block declares a variable that can be passed into the Terraform configuration when it runs.
variable "ssh_key" {
# Configuration for 'description': This line sets the value for the 'description' setting.
  description = "SSH key for server access"
# Configuration for 'type': This line sets the value for the 'type' setting.
  type        = string
  # No default value since it's provided in the secrets.tfvars file.
}

# 'variable' block for 'api_token': This block declares a variable that can be passed into the Terraform configuration when it runs.
variable "api_token" {
# Configuration for 'description': This line sets the value for the 'description' setting.
  description = "Hetzner Cloud API token"
# Configuration for 'type': This line sets the value for the 'type' setting.
  type        = string
  # No default value since it's provided in the secrets.tfvars file.
}

# Add user's SSH key to Hetzner Cloud for server access.
# 'resource' block for '': Terraform will manage an infrastructure component of type 'hcloud_ssh_key'. This is where its configuration is set.
resource "hcloud_ssh_key" "my_key" {
# Configuration for 'name': This line sets the value for the 'name' setting.
  name       = "my-ssh-key"
# Configuration for 'public_key': This line sets the value for the 'public_key' setting.
  public_key = var.ssh_key
}

# Create three web servers with names: "web1", "web2", and "web3".
# 'resource' block for '': Terraform will manage an infrastructure component of type 'hcloud_server'. This is where its configuration is set.
resource "hcloud_server" "web" {
# Configuration for 'count': This line sets the value for the 'count' setting.
  count       = 3
# Configuration for 'name': This line sets the value for the 'name' setting.
  name        = "web${count.index + 1}"
# Configuration for 'server_type': This line sets the value for the 'server_type' setting.
  server_type = "cx21"
# Configuration for 'image': This line sets the value for the 'image' setting.
  image       = "ubuntu-20.04"
# Configuration for 'location': This line sets the value for the 'location' setting.
  location    = "fsn1"
# Configuration for 'ssh_keys': This line sets the value for the 'ssh_keys' setting.
  ssh_keys    = [hcloud_ssh_key.my_key.id]
# Configuration for 'user_data': This line sets the value for the 'user_data' setting.
  user_data   = <<-EOT
#cloud-config
ssh_authorized_keys:
  - ${var.ssh_key}

# 'resource' block for '': Terraform will manage an infrastructure component of type 'null_resource'. This is where its configuration is set.
resource "null_resource" "provisioning_web1" {
  connection {
# Configuration for 'type': This line sets the value for the 'type' setting.
    type        = "ssh"
# Configuration for 'user': This line sets the value for the 'user' setting.
    user        = "ubuntu"
# Configuration for 'private_key': This line sets the value for the 'private_key' setting.
    private_key = file(var.ssh_key)
# Configuration for 'host': This line sets the value for the 'host' setting.
    host        = hcloud_server.web[0].ipv4_address
  }

  provisioner "remote-exec" {
# Configuration for 'inline': This line sets the value for the 'inline' setting.
    inline = [ 
        "sudo apt-get update -y",
        "sudo apt-get install docker.io -y",
        "sudo apt-get install docker-compose -y",
        "sudo apt-get install -y nfs-common",
        "sudo mkdir YOUR_WORDPRESS_SERVER_PATH",
        "sudo mount YOUR_NFS_SERVER_IP:YOUR_NFS_SHARE_PATH YOUR_WORDPRESS_SERVER_PATH",
        "sudo echo 'YOUR_NFS_SERVER_IP:YOUR_NFS_SHARE_PATH YOUR_WORDPRESS_SERVER_PATH nfs defaults 0 0' >> /etc/fstab"
    ]
  }
}

# 'resource' block for '': Terraform will manage an infrastructure component of type 'null_resource'. This is where its configuration is set.
resource "null_resource" "provisioning_web2" {
  connection {
# Configuration for 'type': This line sets the value for the 'type' setting.
    type        = "ssh"
# Configuration for 'user': This line sets the value for the 'user' setting.
    user        = "ubuntu"
# Configuration for 'private_key': This line sets the value for the 'private_key' setting.
    private_key = file(var.ssh_key)
# Configuration for 'host': This line sets the value for the 'host' setting.
    host        = hcloud_server.web[1].ipv4_address
  }

  provisioner "remote-exec" {
# Configuration for 'inline': This line sets the value for the 'inline' setting.
    inline = [ 
        "sudo apt-get update -y",
        "sudo apt-get install docker.io -y",
        "sudo apt-get install docker-compose -y",
        "sudo apt-get install -y nfs-common",
        "sudo mkdir YOUR_WORDPRESS_SERVER_PATH",
        "sudo mount YOUR_NFS_SERVER_IP:YOUR_NFS_SHARE_PATH YOUR_WORDPRESS_SERVER_PATH",
        "sudo echo 'YOUR_NFS_SERVER_IP:YOUR_NFS_SHARE_PATH YOUR_WORDPRESS_SERVER_PATH nfs defaults 0 0' >> /etc/fstab"
    ]
  }
}

# 'resource' block for '': Terraform will manage an infrastructure component of type 'null_resource'. This is where its configuration is set.
resource "null_resource" "provisioning_web3" {
  connection {
# Configuration for 'type': This line sets the value for the 'type' setting.
    type        = "ssh"
# Configuration for 'user': This line sets the value for the 'user' setting.
    user        = "ubuntu"
# Configuration for 'private_key': This line sets the value for the 'private_key' setting.
    private_key = file(var.ssh_key)
# Configuration for 'host': This line sets the value for the 'host' setting.
    host        = hcloud_server.web[2].ipv4_address
  }

  provisioner "remote-exec" {
# Configuration for 'inline': This line sets the value for the 'inline' setting.
    inline = [ 
        "sudo apt-get update -y",
        "sudo apt-get install docker.io -y",
        "sudo apt-get install docker-compose -y",
        "sudo apt-get install -y nfs-common",
        "sudo mkdir YOUR_WORDPRESS_SERVER_PATH",
        "sudo mount YOUR_NFS_SERVER_IP:YOUR_NFS_SHARE_PATH YOUR_WORDPRESS_SERVER_PATH",
        "sudo echo 'YOUR_NFS_SERVER_IP:YOUR_NFS_SHARE_PATH YOUR_WORDPRESS_SERVER_PATH nfs defaults 0 0' >> /etc/fstab"
    ]
  }
}
EOT
}

# Create a load balancer server with the name "LB".
# 'resource' block for '': Terraform will manage an infrastructure component of type 'hcloud_server'. This is where its configuration is set.
resource "hcloud_server" "LB" {
# Configuration for 'name': This line sets the value for the 'name' setting.
  name        = "LB"
# Configuration for 'server_type': This line sets the value for the 'server_type' setting.
  server_type = "cx21"
# Configuration for 'image': This line sets the value for the 'image' setting.
  image       = "ubuntu-20.04"
# Configuration for 'location': This line sets the value for the 'location' setting.
  location    = "fsn1"
# Configuration for 'ssh_keys': This line sets the value for the 'ssh_keys' setting.
  ssh_keys    = [hcloud_ssh_key.my_key.id]
# Configuration for 'user_data': This line sets the value for the 'user_data' setting.
  user_data   = <<-EOT
#cloud-config
ssh_authorized_keys:
  - ${var.ssh_key}
EOT
}

# 'resource' block for '': Terraform will manage an infrastructure component of type 'null_resource'. This is where its configuration is set.
resource "null_resource" "null-example" {
  connection {
# Configuration for 'type': This line sets the value for the 'type' setting.
    type        = "ssh"
# Configuration for 'user': This line sets the value for the 'user' setting.
    user        = "ubuntu"
# Configuration for 'private_key': This line sets the value for the 'private_key' setting.
    private_key = file(var.ssh_key)
# Configuration for 'host': This line sets the value for the 'host' setting.
    host        = hcloud_server.LB.ipv4_address
  }
  provisioner "file" {
# Configuration for 'source': This line sets the value for the 'source' setting.
    source      = "docker-compose.yml"
# Configuration for 'destination': This line sets the value for the 'destination' setting.
    destination = "/home/ubuntu/docker-compose.yml"
}
  provisioner "remote-exec" {
# Configuration for 'inline': This line sets the value for the 'inline' setting.
    inline = [ 
        "sudo sudo apt-get update -y",
        "sudo apt-get install docker.io -y",
        "sudo systemctl start docker",
        "sudo systemctl enable docker",
        "sudo usermod -a -G docker ubuntu",
        "sudo curl -L 'https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)' -o /usr/local/bin/docker-compose", 
        "sudo chmod +x /usr/local/bin/docker-compose",
        "cd /home/ubuntu/ && docker-compose up -d"
     ]
  }
}

# Assign static internal IPs to servers for internal communication.
# 'resource' block for '': Terraform will manage an infrastructure component of type 'hcloud_server_network'. This is where its configuration is set.
resource "hcloud_server_network" "web1_network" {
# Configuration for 'server_id': This line sets the value for the 'server_id' setting.
  server_id  = hcloud_server.web[0].id
# Configuration for 'network_id': This line sets the value for the 'network_id' setting.
  network_id = hcloud_network.my_network.id
# Configuration for 'ip': This line sets the value for the 'ip' setting.
  ip         = "10.0.0.1"
}

# 'resource' block for '': Terraform will manage an infrastructure component of type 'hcloud_server_network'. This is where its configuration is set.
resource "hcloud_server_network" "web2_network" {
# Configuration for 'server_id': This line sets the value for the 'server_id' setting.
  server_id  = hcloud_server.web[1].id
# Configuration for 'network_id': This line sets the value for the 'network_id' setting.
  network_id = hcloud_network.my_network.id
# Configuration for 'ip': This line sets the value for the 'ip' setting.
  ip         = "10.0.0.2"
}

# 'resource' block for '': Terraform will manage an infrastructure component of type 'hcloud_server_network'. This is where its configuration is set.
resource "hcloud_server_network" "web3_network" {
# Configuration for 'server_id': This line sets the value for the 'server_id' setting.
  server_id  = hcloud_server.web[2].id
# Configuration for 'network_id': This line sets the value for the 'network_id' setting.
  network_id = hcloud_network.my_network.id
# Configuration for 'ip': This line sets the value for the 'ip' setting.
  ip         = "10.0.0.3"
}

# 'resource' block for '': Terraform will manage an infrastructure component of type 'hcloud_server_network'. This is where its configuration is set.
resource "hcloud_server_network" "lb_network" {
# Configuration for 'server_id': This line sets the value for the 'server_id' setting.
  server_id  = hcloud_server.LB.id
# Configuration for 'network_id': This line sets the value for the 'network_id' setting.
  network_id = hcloud_network.my_network.id
# Configuration for 'ip': This line sets the value for the 'ip' setting.
  ip         = "10.0.0.4"
}

# Create a floating IP for the load balancer.
# 'resource' block for '': Terraform will manage an infrastructure component of type 'hcloud_floating_ip'. This is where its configuration is set.
resource "hcloud_floating_ip" "lb_floating_ip" {
# Configuration for 'type': This line sets the value for the 'type' setting.
  type          = "ipv4"
# Configuration for 'home_location': This line sets the value for the 'home_location' setting.
  home_location = "fsn1"
# Configuration for 'server_id': This line sets the value for the 'server_id' setting.
  server_id     = hcloud_server.LB.id
}

# Create a private network for inter-server communication.
# 'resource' block for '': Terraform will manage an infrastructure component of type 'hcloud_network'. This is where its configuration is set.
resource "hcloud_network" "my_network" {
# Configuration for 'name': This line sets the value for the 'name' setting.
  name     = "my-unique-network"
# Configuration for 'ip_range': This line sets the value for the 'ip_range' setting.
  ip_range = "10.0.0.0/16"
}

# Define a subnet within the private network.
# 'resource' block for '': Terraform will manage an infrastructure component of type 'hcloud_network_subnet'. This is where its configuration is set.
resource "hcloud_network_subnet" "my_subnet" {
# Configuration for 'network_id': This line sets the value for the 'network_id' setting.
  network_id   = hcloud_network.my_network.id
# Configuration for 'type': This line sets the value for the 'type' setting.
  type         = "cloud"
# Configuration for 'network_zone': This line sets the value for the 'network_zone' setting.
  network_zone = "eu-central"
# Configuration for 'ip_range': This line sets the value for the 'ip_range' setting.
  ip_range     = "10.0.0.0/24"
}
# Create a load balancer to distribute traffic across the WordPress instances
# 'resource' block for '': Terraform will manage an infrastructure component of type 'hcloud_load_balancer'. This is where its configuration is set.
resource "hcloud_load_balancer" "wordpress_lb" {
# Configuration for 'name': This line sets the value for the 'name' setting.
  name       = "wordpress-lb"
# Configuration for 'location': This line sets the value for the 'location' setting.
  location   = "fsn1"
# Configuration for 'algorithm': This line sets the value for the 'algorithm' setting.
  algorithm  = "round_robin"
}

# Add the servers to the load balancer
# 'resource' block for '': Terraform will manage an infrastructure component of type 'hcloud_load_balancer_target'. This is where its configuration is set.
resource "hcloud_load_balancer_target" "web1_target" {
# Configuration for 'type': This line sets the value for the 'type' setting.
  type             = "server"
# Configuration for 'server_id': This line sets the value for the 'server_id' setting.
  server_id        = hcloud_server.web[0].id
# Configuration for 'load_balancer_id': This line sets the value for the 'load_balancer_id' setting.
  load_balancer_id = hcloud_load_balancer.wordpress_lb.id

# Configuration for 'use_private_ip': This line sets the value for the 'use_private_ip' setting.
  use_private_ip = true
}

# 'resource' block for '': Terraform will manage an infrastructure component of type 'hcloud_load_balancer_target'. This is where its configuration is set.
resource "hcloud_load_balancer_target" "web2_target" {
# Configuration for 'type': This line sets the value for the 'type' setting.
  type             = "server"
# Configuration for 'server_id': This line sets the value for the 'server_id' setting.
  server_id        = hcloud_server.web[1].id
# Configuration for 'load_balancer_id': This line sets the value for the 'load_balancer_id' setting.
  load_balancer_id = hcloud_load_balancer.wordpress_lb.id

# Configuration for 'use_private_ip': This line sets the value for the 'use_private_ip' setting.
  use_private_ip = true
}

# 'resource' block for '': Terraform will manage an infrastructure component of type 'hcloud_load_balancer_target'. This is where its configuration is set.
resource "hcloud_load_balancer_target" "web3_target" {
# Configuration for 'type': This line sets the value for the 'type' setting.
  type             = "server"
# Configuration for 'server_id': This line sets the value for the 'server_id' setting.
  server_id        = hcloud_server.web[2].id
# Configuration for 'load_balancer_id': This line sets the value for the 'load_balancer_id' setting.
  load_balancer_id = hcloud_load_balancer.wordpress_lb.id

# Configuration for 'use_private_ip': This line sets the value for the 'use_private_ip' setting.
  use_private_ip = true
}

# Define the service (port) that the load balancer should listen to and forward
# 'resource' block for '': Terraform will manage an infrastructure component of type 'hcloud_load_balancer_service'. This is where its configuration is set.
resource "hcloud_load_balancer_service" "http_service" {
# Configuration for 'load_balancer_id': This line sets the value for the 'load_balancer_id' setting.
  load_balancer_id = hcloud_load_balancer.wordpress_lb.id
# Configuration for 'protocol': This line sets the value for the 'protocol' setting.
  protocol         = "http"
# Configuration for 'listen_port': This line sets the value for the 'listen_port' setting.
  listen_port      = 80
# Configuration for 'destination_port': This line sets the value for the 'destination_port' setting.
  destination_port = 8000

  health_check {
# Configuration for 'protocol': This line sets the value for the 'protocol' setting.
    protocol = "http"
# Configuration for 'port': This line sets the value for the 'port' setting.
    port     = 8000
# Configuration for 'interval': This line sets the value for the 'interval' setting.
    interval = 15
# Configuration for 'retries': This line sets the value for the 'retries' setting.
    retries  = 3
# Configuration for 'timeout': This line sets the value for the 'timeout' setting.
    timeout  = 10
  }
}

# NFS Server Configuration (Pseudo-code)
# 'resource' block for '': Terraform will manage an infrastructure component of type 'hcloud_server'. This is where its configuration is set.
resource "hcloud_server" "nfs_server" {
# Configuration for 'name': This line sets the value for the 'name' setting.
  name        = "nfs-server"
# Configuration for 'server_type': This line sets the value for the 'server_type' setting.
  server_type = "cx11"
# Configuration for 'image': This line sets the value for the 'image' setting.
  image       = "ubuntu-20.04"
# Configuration for 'ssh_keys': This line sets the value for the 'ssh_keys' setting.
  ssh_keys    = [hcloud_ssh_key.my_key.id]
}

# Provisioning the NFS server (Pseudo-code)
# 'resource' block for '': Terraform will manage an infrastructure component of type 'null_resource'. This is where its configuration is set.
resource "null_resource" "nfs_setup" {
  connection {
# Configuration for 'type': This line sets the value for the 'type' setting.
    type        = "ssh"
# Configuration for 'user': This line sets the value for the 'user' setting.
    user        = "ubuntu"
# Configuration for 'private_key': This line sets the value for the 'private_key' setting.
    private_key = file("var.private_ssh_key")
# Configuration for 'host': This line sets the value for the 'host' setting.
    host        = hcloud_server.nfs_server.ipv4_address
  }

  provisioner "remote-exec" {
# Configuration for 'inline': This line sets the value for the 'inline' setting.
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y nfs-kernel-server",
      "sudo mkdir YOUR_NFS_SHARE_PATH",
      "sudo echo 'YOUR_NFS_SHARE_PATH *(rw,no_subtree_check)' >> /etc/exports",
      "sudo systemctl restart nfs-kernel-server"
    ]
  }
}

# Mounting the NFS share on the WordPress servers (Pseudo-code)
# 'resource' block for '': Terraform will manage an infrastructure component of type 'null_resource'. This is where its configuration is set.
resource "null_resource" "mount_nfs" {
  # This should be run for each WordPress server (web1, web2, web3)

  connection {
# Configuration for 'type': This line sets the value for the 'type' setting.
    type        = "ssh"
# Configuration for 'user': This line sets the value for the 'user' setting.
    user        = "ubuntu"
# Configuration for 'private_key': This line sets the value for the 'private_key' setting.
    private_key = file("var.private_ssh_key")
# Configuration for 'host': This line sets the value for the 'host' setting.
    host        = hcloud_server.web[0].ipv4_address # Change index for web2 and web3
  }

  provisioner "remote-exec" {
# Configuration for 'inline': This line sets the value for the 'inline' setting.
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y nfs-common",
      "sudo mkdir YOUR_WORDPRESS_SERVER_PATH",
      "sudo mount YOUR_NFS_SERVER_IP:YOUR_NFS_SHARE_PATH YOUR_WORDPRESS_SERVER_PATH",
      "sudo echo 'YOUR_NFS_SERVER_IP:YOUR_NFS_SHARE_PATH YOUR_WORDPRESS_SERVER_PATH nfs defaults 0 0' >> /etc/fstab"
    ]
  }
}

# DRBD Configuration (Pseudo-code)
# 'resource' block for '': Terraform will manage an infrastructure component of type 'hcloud_server'. This is where its configuration is set.
resource "hcloud_server" "nfs" {
# Configuration for 'count': This line sets the value for the 'count' setting.
  count       = 2
# Configuration for 'name': This line sets the value for the 'name' setting.
  name        = "nfs${count.index + 1}"
# Configuration for 'server_type': This line sets the value for the 'server_type' setting.
  server_type = "YOUR_SERVER_TYPE"
# Configuration for 'image': This line sets the value for the 'image' setting.
  image       = "YOUR_IMAGE"
  ...
}

# 'resource' block for '': Terraform will manage an infrastructure component of type 'null_resource'. This is where its configuration is set.
resource "null_resource" "drbd_setup" {
  # DRBD setup pseudo-code for both NFS servers
}