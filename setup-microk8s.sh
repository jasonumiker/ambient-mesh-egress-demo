#!/bin/bash
# NOTE: Run this with sudo inside microk8s-vm

# Install microk8s
snap install microk8s --channel=1.31/stable --classic

# Enable RBAC
microk8s enable rbac
wait 10

# Install kubectl in microk8s-vm
snap install kubectl --channel 1.31/stable --classic

# Install k9s in microk8s-vm
snap install k9s
sudo ln -s /snap/k9s/current/bin/k9s /snap/bin/

# Install helm in microk8s-vm
snap install helm --classic

# Set up the kubeconfig for both root and Ubuntu users
mkdir /root/.kube
microk8s.config | cat - > /root/.kube/config
mkdir /home/ubuntu/.kube/
cp /root/.kube/config /home/ubuntu/.kube/config
chown ubuntu:ubuntu -R /home/ubuntu/.kube

# Install Ambient Mesh
cd /root
wget -O install-ambient-mesh.sh https://get.ambientmesh.io
chmod +x ./install-ambient-mesh.sh
DISTRO=microk8s ./install-ambient-mesh.sh
curl -sL https://istio.io/downloadIstioctl | sh -
export PATH=$HOME/.istioctl/bin:$PATH
