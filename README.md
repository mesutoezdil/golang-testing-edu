***In-depth Overview of Terraform Configuration (`main.tf`):**
   - Terraform is a powerful Infrastructure as Code (IaC) tool.
   - The `main.tf` file is used to provision virtual server instances on Hetzner Cloud.

***Detailed Overview of Docker Compose (`docker-compose.yml`):**
   - Docker Compose is a tool for defining and running multi-container Docker applications.
   - Services like `db1, db2, db3` represent the Percona XtraDB Cluster and are configured using environment variables.

***In-depth Overview of Project Configuration Files:**
   - `haproxy.cfg`: Contains general, default, frontend, and backend configurations for HAProxy.
   - `terraform.tfvars`: Contains variable definitions for the Terraform configuration.
   - `haproxy.pem`: An SSL/TLS certificate file used by HAProxy for encrypted connections.

Note: For security reasons, sensitive data such as API tokens, SSH keys, or certificates should never be publicly shared. Ensure they are securely stored.


# In-depth Overview of Terraform Configuration (`main.tf`)

### Introduction:
Terraform is a powerful Infrastructure as Code (IaC) tool. The `main.tf` file in this project defines and configures the infrastructure components required for the deployment of the application.

### Detailed Resource Descriptions:

- **hcloud_server (web)**: 
  - **Purpose**: Used to provision virtual server instances on Hetzner Cloud.
  - **Parameters**:
    - `server_type`: Defines the size and capacity of the server (e.g., "cx21" which might determine CPU, RAM, and storage).
    - `image`: Specifies the OS image to be used (e.g., "ubuntu-20.04").
    - `location`: Determines the data center or geographic location of the server.
    - `ssh_keys`: Lists the SSH keys that should be added to the server for secure access.
    - `user_data`: Provides cloud-config scripts. In this case, it's used to inject SSH keys.

- **null_resource (provisioning_web1, provisioning_web2, ...)**: 
  - **Purpose**: While the `null_resource` doesn't create actual infrastructure, it triggers other actions or tasks. Here, it's used for post-provisioning tasks on the servers.
  - **Parameters**:
    - `connection`: Defines how Terraform should connect to the instance. Details like `type` (SSH), `user`, `private_key`, and `host` are specified.
    - `provisioners`: Scripts or commands to be executed. They handle the installation of Docker, Docker Compose, and the setup of NFS.

- **hcloud_server (nfs)**: 
  - **Purpose**: Represents the servers meant for NFS (Network File System) setup. NFS is crucial for shared storage across instances.
  - **Parameters** (Pseudo-code/Template):
    - `count`: Specifies the number of such servers to be created.
    - `name`: Naming convention for these servers.
    - `server_type` & `image`: Similar to the `web` server setup, they define the server's characteristics and base OS.

- **null_resource (drbd_setup)**: 
  - **Purpose**: Placeholder or pseudo-code for setting up DRBD (Distributed Replicated Block Device). DRBD is a distributed storage system used for mirroring block devices between multiple hosts.

### Conclusion:
The `main.tf` file provides a comprehensive blueprint for the infrastructure setup. It ensures that the required servers are provisioned with the necessary software and configurations. When executed, Terraform will use this file to create and configure the servers on Hetzner Cloud, preparing them for the application's deployment.

It's essential to ensure that the placeholders in the configuration (like `YOUR_NFS_SERVER_IP`) are replaced with actual values before executing the Terraform plan.

# Detailed Overview of Docker Compose (`docker-compose.yml`)

### General Information:
Docker Compose is a tool for defining and running multi-container Docker applications. The `docker-compose.yml` file defines how services are built, which ports they listen to, which environment variables they use, and dependencies between containers.

### Detailed Services and Parameters:

- **db1, db2, db3**: 
  - These services represent the Percona XtraDB Cluster.
  - Configured using environment variables such as `MYSQL_ROOT_PASSWORD`, `MYSQL_DATABASE`, `MYSQL_USER`, `MYSQL_PASSWORD`, `CLUSTER_NAME`, and `XTRABACKUP_PASSWORD`.
  - The `db2` and `db3` services are dependent on the `db1` service.

- **wordpress1 & wordpress2**: 
  - These services represent the WordPress applications.
  - Database connection details are provided using environment variables like `WORDPRESS_DB_HOST`, `WORDPRESS_DB_USER`, `WORDPRESS_DB_PASSWORD`, and `WORDPRESS_DB_NAME`.
  - They utilize persistent storage through NFS.

- **haproxy**: 
  - This service represents the HAProxy load balancer.
  - Traffic is directed based on the rules defined in the `haproxy.cfg` file.
  - SSL/TLS encryption is provided using certificates from the `certbot` service.
  - It's dependent on the `wordpress1` and `wordpress2` services.

- **certbot**: 
  - Used to obtain SSL certificates.
  - Requests a certificate for a specific domain (`wordpress-mo.senecops.com`) and an email address.

- **keepalived1 & keepalived2**: 
  - Provides high availability using Keepalived.
  - Used to manage the VIP (Virtual IP) address.
  - Dependent on the `haproxy` service.

### Conclusion:
This `docker-compose.yml` file defines the necessary infrastructure to run a WordPress application with high availability. The application and its dependencies run as Docker containers as defined in this file.

# In-depth Overview of Project Configuration Files

### 1. `haproxy.cfg` - HAProxy Configuration File:

### Global Settings:
- **global**: Contains settings that apply globally to the HAProxy process.
  - **log**: Defines logging directives.

### Default Settings:
- **defaults**: Default settings affecting all frontend and backend sections.
  - **log, mode, timeout**: Logging, operational mode, and timeout settings.

### Frontend Settings:
- **frontend**: Defines where HAProxy listens for incoming traffic.
  - **bind**: IP addresses and ports for HAProxy to listen.
  - **default_backend**: Backend section for traffic forwarding.

### Backend Settings:
- **backend**: Where HAProxy sends incoming traffic.
  - **balance**: Load balancing algorithm.
  - **server**: Backend servers for traffic forwarding.

### 2. `terraform.tfvars` - Terraform Variables File:
Contains variable definitions for the Terraform configuration.
- **ssh_key**: SSH public key for server access.
- **api_token**: Authentication token for Hetzner Cloud.

### 3. `haproxy.pem` - SSL/TLS Certificate File:
An SSL/TLS certificate file used by HAProxy for encrypted connections. The content should be kept confidential.

### Note:
For security reasons, sensitive data like API tokens, SSH keys, or certificates should never be publicly shared. Always ensure they are securely stored.
