variable "env" {
  description = "Environment name (prod/nonprod)"
  type        = string
}

variable "backend_uri" {
  description = "The HTTP URI of the backend service (internal LB DNS)"
  type        = string
}

variable "lb_arns" {
  description = "List of internal Load Balancer ARNs for VPC Link"
  type        = list(string)
}

variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "eu-west-1"
}