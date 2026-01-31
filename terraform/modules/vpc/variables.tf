variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "env" {
  description = "Environment name (e.g. dev, nonprod, prod)"
  type        = string
}

