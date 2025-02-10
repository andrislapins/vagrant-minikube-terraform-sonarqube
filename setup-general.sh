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
apt-get install -y apt-transport-https gnupg2 software-properties-common unzip containerd bridge-utils conntrack

# Install KVM/QEMU for Minikube
echo "Installing KVM/QEMU for Minikube..."
apt-get install -y qemu-kvm libvirt-daemon-system libvirt-clients virt-manager

# Ensure libvirt is running
systemctl enable libvirtd
systemctl start libvirtd

# Add user to libvirt and kvm groups
usermod -aG libvirt,kvm $NON_ROOT_USER

# Install kubectl if not installed
if ! command -v kubectl &> /dev/null; then
  echo "Installing kubectl..."
  curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
  install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
  rm kubectl
fi

# Install Minikube if not installed
if ! command -v minikube &> /dev/null; then
  echo "Installing Minikube..."
  curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
  install minikube-linux-amd64 /usr/local/bin/minikube
  rm minikube-linux-amd64
fi

# Install Helm (Helm 3)
if ! command -v helm &> /dev/null; then
  echo "Installing Helm..."
  curl -LO https://get.helm.sh/helm-v3.12.0-linux-amd64.tar.gz
  tar -zxvf helm-v3.12.0-linux-amd64.tar.gz
  mv linux-amd64/helm /usr/local/bin/helm
  rm -rf linux-amd64 helm-v3.12.0-linux-amd64.tar.gz
fi

# Install Terraform if not installed
if ! command -v terraform &> /dev/null; then
  echo "Installing Terraform..."
  curl -LO https://releases.hashicorp.com/terraform/1.5.0/terraform_1.5.0_linux_amd64.zip
  unzip terraform_1.5.0_linux_amd64.zip
  mv terraform /usr/local/bin/
  rm terraform_1.5.0_linux_amd64.zip
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