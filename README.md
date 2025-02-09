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

<span style="color: red; font-weight: bold;">NOTE:</span> You need to provide a `.tfvars` file (e.g., `terraform/secrets.auto.tfvars`) to ensure the SonarQube and PostgreSQL passwords are applied.
For example:
```hcl
# terraform/secrets.auto.tfvars
postgres_password = "secretpassword"
sonar_db_password = "secretpassword"
```

1. **Clone the repository and start up Vagrant:**
   ```bash
   git clone git@github.com:andrislapins/vagrant-minikube-terraform-sonarqube.git
   cd vagrant-minikube-terraform-sonarqube
   vagrant up
   ```