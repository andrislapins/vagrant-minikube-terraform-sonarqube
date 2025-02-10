# SonarQube on Minikube with Terraform & Helm

This repository primarly demonstrates an automated deployment of SonarQube on a Minikube cluster using Terraform and Helm. 
Host system setup for the whole deployment has been tested using Vagrant and `setup-general.sh` Bash script.
Check out `setup-general.sh` for dependencies if preparing your environment without Vagrant.
The setup performs the following tasks:

1. **Installs Required Tools:**  
   - Minikube  
   - Helm (v3)  
   - kubectl  
   - Terraform

2. **Starts a Minikube Cluster:**  
   Minikube is started using the KVM driver and the Nginx ingress addon is enabled.

3. **Deploys PostgreSQL and SonarQube via Helm (using Terraform):**  
   - PostgreSQL is deployed using the Bitnami PostgreSQL chart.  
   - SonarQube is deployed using the Bitnami SonarQube chart and is configured to use the external PostgreSQL database.

4. **Configures Ingress:**  
   SonarQube is exposed via an Ingress.
   You can set the desired URL to access SonarQube on the browser in Terraform `variables.tf` file.
   For example, `sonarqube.local`.

## How to Run

```bash
git clone git@github.com:andrislapins/vagrant-minikube-terraform-sonarqube.git
cd vagrant-minikube-terraform-sonarqube
```

<span style="color: red; font-weight: bold;">NOTE:</span> Tested only on Ubuntu 24.04 LTS

<span style="color: red; font-weight: bold;">NOTE:</span> You need to provide a `.tfvars` file (e.g., `terraform/secrets.auto.tfvars`) to ensure the SonarQube and PostgreSQL passwords are applied.
For example:
```hcl
# terraform/secrets.auto.tfvars
postgres_password = "secretpassword"
sonar_db_password = "secretpassword"
```

### **Option 1: Launch locally**
```bash
./setup-general.sh
```

### **Option 2: Launch using Vagrant**

Install Vagrant:
```bash
wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install vagrant
```
Source: https://developer.hashicorp.com/vagrant/downloads

Setup Vagrant:
```bash
vagrant init
vagrant plugin install vagrant-libvirt
```

Sadly, there is no support for newer Ubuntu versions on Vagrant - https://askubuntu.com/questions/1520083/are-there-vagrant-boxes-for-recent-ubuntu-releases.
I had to download a specific Vagrant box with libvirt support.
Donwload the box I used from https://portal.cloud.hashicorp.com/vagrant/discover/generic/ubuntu2004 and add it to Vagrant:
```bash
vagrant box add --name my-ubuntu-20.04 <path/to/the/downloaded/box>
```

Launch:
```bash
vagrant up
```

To destroy your Vagrant setup without being prompted:
```bash
vagrant destroy -f 
```