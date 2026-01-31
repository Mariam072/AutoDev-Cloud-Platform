variable "vpc_id" {
  description = "ID of the VPC where resources will be created"
  type        = string
}

variable "azs" {
  description = "List of Availability Zones to use"
  type        = list(string)
}

variable "env" {
  description = "Environment name (e.g. dev, nonprod, prod)"
  type        = string
}

