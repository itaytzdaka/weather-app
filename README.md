
# [WEATHER]

> [SHORT_PROJECT_DESCRIPTION] - A simple app for getting weather by location.


[project-heroku-link]
https://itay-weather-app-dc1f7134ea9c.herokuapp.com/


## Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Technology Stack](#technology-stack)
- [Repository Structure](#repository-structure)
- [Prerequisites](#prerequisites)
- [Getting Started](#getting-started)
- [CI/CD Pipeline](#cicd-pipeline)
- [Contributing](#contributing)
- [Release History](#release-history)
- [Contact](#contact)
- [Acknowledgments](#acknowledgments)

## Overview

This project is a weather web application that allows users to search the current weather of a city by name.

Key features:

- [CI/CD]
- [IaC]
- [GitOps]

## Architecture

[ARCHITECTURE_DESCRIPTION]

![Architecture Diagram](images/architecture_diagram.png)

## Technology Stack

| Category             | Technologies   |
| -------------------- | -------------- |
| **Application**      | [REACT+NODEJS] |
| **Version Control**  | [GITHUB]       |
| **Containerization** | [DOCKER]       |
| **CI/CD**            | [JENKINS]      |
| **Infrastructure**   | [TERRAFORM]    |


## Repository Structure


project-root/
|
├─── client/
|    ├── src/
│    └── Dockerfile              
│
├─── server/
|    ├── app.js
│    └── Dockerfile              
│
├─── infrastructure/
|    ├── main.tf                 # Root Terraform file orchestrating modules
|    ├── variables.tf            # Input variables
|    ├── outputs.tf              # Outputs from the root module
|    ├── providers.tf            # AWS and Kubernetes providers
|    ├── terraform.tfvars        # Default variable values
|    ├── secrets.tf              # Sensitive values (excluded from version control)
|    ├── prod.tfvars             # Production environment values
|    └── modules/
|       ├── eks/                 # Provisions EKS cluster and node groups
|       ├── network/             # Provisions VPC, subnets, gateways, etc.
|       └── argocd/              # Installs ArgoCD and optionally deploys App-of-Apps
|
├─── gitops/
|    ├── app-of-apps.yaml        # ArgoCD App of Apps root configuration
|    ├── argo-apps/              # ArgoCD Application CRs (each deploys a chart)               
│    │  ├── application.yaml     # WEATHER Application
│    │  ├── cert-manager.yaml
│    │  ├── ingress-nginx.yaml
|    ├── charts/                 # Local Helm charts




### Getting Started, running the project:



# ##################################################
#     Option 1: run with docker compose            #
# ##################################################


Prerequisites:

- [docker-compose]

$ cd weather
$ docker compose up -d

http://localhost


# ##################################################
#     Option 2: run with minikube and argocd       #
# ##################################################

Prerequisites:

- [minikube]
- [argocd]

# argocd installation:

$ kubectl create namespace argocd
    
    namespace/argocd created

$ kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml


$ kubectl port-forward svc/argocd-server -n argocd 8080:443

    https://localhost:8080

    user: admin
    password: run command:

$ kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 --decode


$ cd weather
$ cd gitops

$ kubectl apply -f app-of-apps.yaml

$ kubectl get ingress -n app

    add ingress ip address with "weather.local" to /etc/hosts:

    example: 
    10.108.224.111 weather.local

    https://weather.local/


# ########################################################
#     option 3: deploy to AWS cloud with terraform       #
# ########################################################


# Prerequisites:

- [Terraform >= v1.10.0]

Follow these instructions to set up the project locally and deploy it to your cloud environment.

### Infrastructure Setup

$ cd infrastructure
$ terraform init -reconfigure
$ terraform workspace new prod

### Application Deployment

$ terraform apply -var-file=$(terraform workspace show).tfvars

Expected result: Plan: 30 to add, 0 to change, 0 to destroy.

## CI/CD Pipeline

This project supports a CI/CD pipeline to automate infrastructure provisioning and application deployment using Terraform and Jenkins.


graph LR
    A[Clone GitLab repository] --> B[Install Python dependencies]
    B --> C[Run unit tests]
    C --> D[Run end-to-end (E2E) tests]
    D --> E[Build Production Docker images]
    E --> F[Calculate new version]
    F --> G[Push images to Amazon ECR]
    G --> H[Tag commit in GitLab]
    H --> I[Deploy application]
    I --> J[Report status]


## Contact

[Itay_Tzdaka] - LinkedIn - [itaytzdaka1@gmail.com]

Project Link: [https://github.com/itaytzdaka/weather-app]

## Acknowledgments

- [Terraform by HashiCorp](https://www.terraform.io/) – for enabling infrastructure as code
- [Amazon Web Services (AWS)](https://aws.amazon.com/) – for scalable and secure cloud infrastructure
- [Amazon EKS](https://aws.amazon.com/eks/) – for managing Kubernetes clusters at scale
- [Amazon ECR](https://aws.amazon.com/ecr/) – for hosting and managing Docker images
- [ArgoCD](https://argo-cd.readthedocs.io/) – for GitOps-based Kubernetes application delivery
- [Bitnami Helm Charts](https://bitnami.com/stacks/helm) – for production-ready Kubernetes packages
- [Jenkins](https://www.jenkins.io/) – for automating CI/CD pipelines