#!/bin/bash

# Set CRI socket variable
CRI_SOCKET="unix:///var/run/containerd/containerd.sock"  # Change to `unix:///var/run/crio/crio.sock` if using CRI-O

# Pull necessary images
sudo kubeadm config images pull

# Initialize Kubernetes cluster
sudo kubeadm init --cri-socket $CRI_SOCKET

# Setup kubeconfig for the current user
mkdir -p "$HOME/.kube"
sudo cp -i /etc/kubernetes/admin.conf "$HOME/.kube/config"
sudo chown "$(id -u)":"$(id -g)" "$HOME/.kube/config"

# Apply Calico network plugin
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.26.0/manifests/calico.yaml

# Print join command for worker nodes
kubeadm token create --print-join-command
