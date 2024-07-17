#vim .bashrc
#export PATH=$PATH:/usr/local/bin/
#source .bashrc

#!/bin/bash

# Configure AWS CLI
aws configure

# Download kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

# Download kops
wget https://github.com/kubernetes/kops/releases/download/v1.25.0/kops-linux-amd64

# Make binaries executable
chmod +x kops-linux-amd64 kubectl

# Move binaries to /usr/local/bin
mv kubectl /usr/local/bin/kubectl
mv kops-linux-amd64 /usr/local/bin/kops

# Add /usr/local/bin to PATH
export PATH=$PATH:/usr/local/bin

# Create S3 bucket in eu-north-1 region
aws s3api create-bucket --bucket kunaljoshi.k8s.local --create-bucket-configuration LocationConstraint=eu-north-1

# Enable versioning on the S3 bucket
aws s3api put-bucket-versioning --bucket kunaljoshi.k8s.local --versioning-configuration Status=Enabled

# Set KOPS_STATE_STORE environment variable
export KOPS_STATE_STORE=s3://kunaljoshi.k8s.local

# Create Kubernetes cluster with kops
kops create cluster --name kunaljoshi.k8s.local --zones eu-north-1a --master-count=1 --master-size t3.medium --node-count=2 --node-size t3.medium

# Update the cluster
kops update cluster --name kunaljoshi.k8s.local --yes --admin
