# Environment (prod / nonprod)
variable "env" {
  type        = string
  description = "Environment name"
}

# AWS region
variable "aws_region" {
  type        = string
  description = "AWS Region to deploy the infrastructure"
}

# EKS cluster name
variable "cluster_name" {
  type        = string
  description = "Name of the EKS cluster"
}

# VPC CIDR block
variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
}

# Subnets configuration
variable "public_subnet_count" {
  type        = number
  description = "Number of public subnets"
}

variable "private_subnet_count" {
  type        = number
  description = "Number of private subnets"
}

# Node group configuration
variable "node_group_instance_type" {
  type        = string
  description = "Instance type for EKS managed node group"
}

variable "node_group_desired_size" {
  type        = number
  description = "Desired number of nodes in the node group"
}

variable "node_group_min_size" {
  type        = number
  description = "Minimum number of nodes in the node group"
}

variable "node_group_max_size" {
  type        = number
  description = "Maximum number of nodes in the node group"
}


# Optional: if you want custom ports
variable "nlb_listener_port" {
  type    = number
  default = 80
  description = "Port for the NLB listener"
}

variable "nlb_target_port" {
  type    = number
  default = 80
  description = "Port for the NLB target group"
}

