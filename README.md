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
Key Components

VPC & Networking — Public + private subnets, NAT, IGW
EKS — Managed node groups + IAM roles (IRSA-ready)
Ingress — NGINX + AWS API Gateway (edge → internal ingress)
GitOps — Argo CD (syncs nonprod / prod paths)
Observability — Datadog agent
Secrets — AWS SSM Parameter Store + IRSA
Images — Amazon ECR with scanning
Database — MongoDB Atlas (URI injected at runtime)

🚀 Pipelines Summary
1. Infrastructure Pipeline (Terraform)

Checkout code
terraform apply creates:
VPC, subnets (public/private), IGW, NAT Gateway, route tables
IAM roles (EKS control plane + nodes + IRSA)
EKS cluster + managed node groups
API Gateway (optional edge routing)

Installs tooling: kubectl, helm
Configures kubeconfig + verifies cluster
Helm charts:
ingress-nginx
argo-cd
datadog

Creates namespaces, ingress resources, API Gateway → Ingress integration
Secrets: AWS SSM Parameter Store + workload IAM permissions
Outputs: API Gateway URL, Ingress endpoint, cluster details

2. CI Pipeline (Image Builds)

Checkout
Build Docker image(s)
Tag with commit SHA (immutable)
Authenticate → Amazon ECR
Push image
Scan image (ECR basic scanning)
Publish tag(s) for Argo CD to consume
(Manual / separate step) MongoDB Atlas cluster creation
Store Atlas connection URI → AWS SSM

3. CD / GitOps (Argo CD)

Watches Git repository paths: nonprod/, prod/
Deploys Helm charts & raw manifests
Validates image scan status before sync (optional policy)
Pulls secrets at runtime:
MongoDB Atlas URI from SSM Parameter Store
Injected into Kubernetes Secrets / environment variables


📋 Prerequisites

AWS account with permissions for: VPC, EKS, ECR, IAM, SSM, API Gateway
Terraform ≥ 1.5
AWS CLI configured
kubectl & helm (installed by pipeline or locally)
MongoDB Atlas account (free tier works for PoC)
GitHub repository for application manifests (GitOps repo)

🛠️ Getting Started
Bash# 1. Clone infra repo
git clone https://github.com/your-org/final-abstracted-infra.git
cd final-abstracted-infra

# 2. Configure backend & variables
cp terraform.tfvars.example terraform.tfvars
# edit: region, cluster name, vpc cidr, node size, etc.

# 3. Initialize & apply (use your CI or locally with care)
terraform init
terraform plan -out=tfplan
terraform apply tfplan
After infra is ready:

Get Argo CD admin password: kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
Access Argo CD UI (via ingress or port-forward)
Point Argo CD to your application GitOps repo

🗂 Repository Structure (suggested)
text.
├── terraform/
│   ├── main.tf
│   ├── eks.tf
│   ├── networking.tf
│   ├── addons.tf
│   ├── outputs.tf
│   └── variables.tf
├── argocd/
│   ├── values.yaml           # Argo CD bootstrap values
│   └── application-sets/
├── docs/
└── README.md
(The actual application manifests live in a separate GitOps repo.)
🔒 Security Considerations

Least-privilege IAM roles (IRSA)
No long-lived secrets in git
Container image scanning enforced
Private subnets for nodes
SSM for cross-service secrets
Enforce network policies (future)
Rotate Argo CD admin password immediately

🛠️ Roadmap / Future Enhancements

 ExternalDNS + cert-manager
 IRSA for Datadog & other addons
 Multi-region / multi-cluster Argo CD
 Kyverno / OPA Gatekeeper policies
 Automated cleanup / destroy pipeline
 Cost allocation tags

📄 License
MIT License — feel free to use, fork, and contribute.
🙌 Acknowledgments
Built with inspiration from AWS EKS Blueprints, CloudPosse components, and the GitOps community.
Questions? Open an issue or reach out!
textThis README is comprehensive yet scannable, uses modern markdown features (badges, mermaid diagram, code blocks), and clearly communicates the value of the project to potential users, contributors, or future team members.

Feel free to adjust project name, organiz
