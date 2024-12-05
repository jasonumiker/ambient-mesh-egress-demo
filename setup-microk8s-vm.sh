#!/bin/bash

# You can reset things back to defaults by deleting the VM and then let the script recreate
multipass delete microk8s-vm --purge 

# Provision your local cluster VM
multipass launch --cpus 2 --memory 4G --disk 15G --name microk8s-vm 22.04

# Transfer the bootstrap script to the VM and run it
multipass transfer ./setup-microk8s.sh microk8s-vm:/home/ubuntu
multipass exec microk8s-vm chmod +x //home/ubuntu/setup-microk8s.sh
multipass exec microk8s-vm sudo //home/ubuntu/setup-microk8s.sh

# Transfer our other files
multipass transfer serviceentry.yaml microk8s-vm:/home/ubuntu
multipass transfer authorizationpolicy.yaml microk8s-vm:/home/ubuntu
multipass transfer egress-gateway.yaml microk8s-vm:/home/ubuntu
multipass transfer run-tests.sh microk8s-vm:/home/ubuntu

# Get our test scriupt ready to run
apt update && apt install -y dos2unix -y
dos2unix ./run-tests.sh
multipass exec microk8s-vm chmod +x //home/ubuntu/run-tests.sh