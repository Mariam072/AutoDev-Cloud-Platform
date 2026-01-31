
variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "eu-west-1"
}

variable "env" {
  description = "Environment name (nonprod / prod)"
  type        = string
 
}


variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "azs" {
  description = "Availability Zones"
  type        = list(string)
  default     = [
    "eu-west-1a",
    "eu-west-1b"
  ]
}


#variable "key_name" {
#  description = "EC2 key pair name for EKS nodes"
#  type        = string
#  default     = "mariam-key"
#}



variable "cluster_version" {
 description = "Kubernetes version for the EKS cluster"
 type        = string
  default     = "1.27"
}




variable "instance_types" {
  description = "EC2 instance types for EKS managed node group"
  type        = list(string)
  default     = ["t3.small"]
}

variable "node_min" {
  description = "Minimum number of worker nodes in the EKS node group"
  type        = number
  default     = 1
}

variable "node_max" {
  description = "Maximum number of worker nodes in the EKS node group"
  type        = number
  default     = 3
}

variable "node_desired" {
  description = "Desired number of worker nodes in the EKS node group"
  type        = number
  default     = 2
}
