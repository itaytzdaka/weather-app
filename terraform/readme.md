# Terraform AWS Infrastructure

## Overview

This repository provisions a complete AWS infrastructure using Terraform. It includes:

- A VPC with public and private subnets
- An EKS cluster for container orchestration
- ArgoCD for GitOps continuous delivery
- IAM roles and necessary policies
- Configured with best practices for modularity, reusability, and security

## Requirements

- **Terraform**: `>= 1.3.0`
- **AWS CLI**: Configured with a user or role that has admin permissions or specific IAM permissions for EKS, VPC, IAM, etc.
- **kubectl**: For interacting with the Kubernetes cluster
- **helm**: For Helm-based deployments (e.g., ArgoCD)

### Pre-requisites

- AWS credentials configured via `aws configure` or environment variables
- An S3 backend (optional) for remote state management (not included by default)
- A default AWS region set in your environment or `providers.tf`

## Module Structure

```plaintext
.
├── main.tf                 # Root Terraform file orchestrating modules
├── variables.tf            # Input variables
├── outputs.tf              # Outputs from the root module
├── providers.tf            # AWS and Kubernetes providers
├── terraform.tfvars        # Default variable values
├── secrets.tf              # Sensitive values (excluded from version control)
├── prod.tfvars             # Production environment values
└── modules/
    ├── eks/                # Provisions EKS cluster and node groups
    ├── network/            # Provisions VPC, subnets, gateways, etc.
    └── argocd/             # Installs ArgoCD and optionally deploys App-of-Apps
