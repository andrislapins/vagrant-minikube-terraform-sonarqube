#!/bin/bash

set -ex

# Check if running as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root or using sudo."
  exit 1
fi

# Define non-root user (Vagrant or other)
# Check if the non-root user exists
NON_ROOT_USER="vagrant"
NON_ROOT_USER_PWD="vagrantUSER123"

if ! id "$NON_ROOT_USER" &>/dev/null; then
  echo "User '$NON_ROOT_USER' does not exist. Creating..."
  useradd -m -s /bin/bash "$NON_ROOT_USER"
  echo "$NON_ROOT_USER:$NON_ROOT_USER_PWD" | chpasswd  
  echo "$NON_ROOT_USER ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/99-$NON_ROOT_USER
fi

# Updating package list
echo "Updating package list..."
apt-get update

# Installing prerequisites
echo "Installing prerequisites..."
apt-get install -y curl ca-certificates apt-transport-https gnupg2 software-properties-common unzip containerd bridge-utils conntrack

# Install KVM/QEMU for Minikube
echo "Installing KVM/QEMU for Minikube..."
apt-get install -y qemu-kvm libvirt-daemon-system libvirt-clients virt-manager

# Ensure libvirt is running
systemctl enable libvirtd
systemctl start libvirtd

# Add user to libvirt and kvm groups
usermod -aG libvirt,kvm $NON_ROOT_USER

# Install kubectl if not installed
# Source: https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/
if ! command -v kubectl &> /dev/null; then
  echo "Installing kubectl..."
  curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
  sudo mkdir -p -m 755 /etc/apt/keyrings
  curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.32/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
  sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg
  echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.32/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
  sudo chmod 644 /etc/apt/sources.list.d/kubernetes.list
  sudo apt-get update
  sudo apt-get install -y kubectl
fi

# Install Minikube if not installed
# Source: https://minikube.sigs.k8s.io/docs/start/?arch=%2Flinux%2Fx86-64%2Fstable%2Fdebian+package
if ! command -v minikube &> /dev/null; then
  echo "Installing Minikube..."
  curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube_latest_amd64.deb
  sudo dpkg -i minikube_latest_amd64.deb
fi

# Install Helm (Helm 3)
# Source: https://helm.sh/docs/intro/install/
if ! command -v helm &> /dev/null; then
  curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
  sudo apt-get update
  sudo apt-get install -y helm
fi

# Install Terraform if not installed
# Source: https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli
if ! command -v terraform &> /dev/null; then
  echo "Installing Terraform..."
  wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
  echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
  sudo apt update
  sudo apt-get install -y terraform
fi

# Starting Minikube
echo "Starting Minikube..."
sudo -u $NON_ROOT_USER -- bash -c "minikube start \
  --driver=kvm2 \
  --container-runtime=containerd \
  --cpus=4 \
  --memory=8gb \
  --disk-size=20gb"

# For technical simplicity, use Minikube addon instead of configuring Nginx Helm
# chart with ExternalIP of Minikube IP
sudo -u $NON_ROOT_USER -- bash -c "minikube addons enable ingress"

# Initializing and applying Terraform configuration
echo "Initializing and applying Terraform configuration..."
cd /home/vagrant/project/terraform
sudo -u $NON_ROOT_USER -- bash -c "terraform init"
sudo -u $NON_ROOT_USER -- bash -c "terraform apply -auto-approve"

# Configuring /etc/hosts to map sonarqube.local to Minikube IP
echo "Configuring /etc/hosts to map sonarqube.local to Minikube IP..."
MINIKUBE_IP=$(sudo -u $NON_ROOT_USER -- bash -c "minikube ip")
SONAR_HOSTNAME=$(sudo -u $NON_ROOT_USER -- bash -c "terraform output -raw sonar_hostname")
echo "$MINIKUBE_IP $SONAR_HOSTNAME" >> /etc/hosts

# Completing the setup
echo "----------------------------------------------------"
echo "Deployment is complete."
echo "Access SonarQube at: http://$SONAR_HOSTNAME"
echo "----------------------------------------------------"