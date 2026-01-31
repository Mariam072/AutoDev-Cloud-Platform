Terraform infrastructure for AutoDev Cloud Platform
terraform-aws-autodev/
├── main.tf
├── variables.tf
├── outputs.tf
├── providers.tf
├── backend.tf
├── prod.auto.tfvars
├── nonprod.auto.tfvars
└── modules/
├── vpc/
├── eks/
├── iam/
├── subnets/
└── routing/

text

## Usage
```bash
# Initialize
terraform init

# Plan
terraform plan -var-file="prod.auto.tfvars"

# Apply
terraform apply -var-file="prod.auto.tfvars"
Modules
vpc: VPC Network

eks: EKS Cluster

iam: IAM Roles & Policies

subnets: Subnet Configuration

routing: Route Tables

Requirements
Terraform >= 1.0

AWS Provider >= 4.0
