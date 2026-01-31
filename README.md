# AutoDev-Cloud-Platform
# Final Abstracted Infra, CI & CD Plan

Modern AWS EKS platform bootstrapped with **Terraform**, **GitOps** via **Argo CD**, **Helm**, and secure secrets handling — designed for production-grade, repeatable deployments.

[![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?style=for-the-badge&logo=amazon-aws&logoColor=white)](https://aws.amazon.com)
[![Terraform](https://img.shields.io/badge/Terraform-623CE4?style=for-the-badge&logo=terraform&logoColor=white)](https://www.terraform.io)
[![EKS](https://img.shields.io/badge/Amazon%20EKS-267FCA?style=for-the-badge&logo=amazon-eks&logoColor=white)](https://aws.amazon.com/eks/)
[![ArgoCD](https://img.shields.io/badge/ArgoCD-EF2B8A?style=for-the-badge&logo=argo&logoColor=white)](https://argoproj.github.io/cd/)
[![GitOps](https://img.shields.io/badge/GitOps-1793D1?style=for-the-badge)](https://www.gitops.tech)

## 📖 Overview

This repository contains **Infrastructure as Code (IaC)** and **GitOps** configuration to provision and operate a secure, production-ready Amazon EKS cluster with:

- Full networking stack (VPC, subnets, NAT, IGW)
- Managed node groups
- Ingress-NGINX + API Gateway integration
- Argo CD for declarative continuous deployment
- Datadog observability
- Image scanning in Amazon ECR
- MongoDB Atlas integration (connection string via AWS SSM)
- Secrets managed securely (no hard-coded credentials)

The solution follows a clean separation:

- **Infrastructure Pipeline** → Terraform → creates AWS resources + bootstraps Argo CD
- **CI Pipeline** → builds & publishes container images to ECR
- **CD (GitOps)** → Argo CD continuously syncs application manifests / Helm charts

## ✨ Architecture

```mermaid
flowchart TD
    A[Git Push → Application Code / Manifests] --> B[CI Pipeline]
    B --> C[Build Docker → Scan → Push ECR]
    C --> D[Argo CD Watches GitOps Repo]
    D --> E[EKS Cluster]
    F[Terraform Apply] --> E
    F --> G[Install: ingress-nginx, Argo CD, Datadog]
    H[MongoDB Atlas] --> I[SSM Parameter Store]
    I --> J[Argo CD → Inject secret to Pods]
    G --> K[Ingress → API Gateway → Public Traffic]

