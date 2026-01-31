variable "env" {
  description = "Environment name (e.g., prod, nonprod)"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID where the resources will be created"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}
