variable "cluster_name" { type = string }
variable "env" { type = string }
#variable "aws_account_id" { type = string }
variable "aws_region" {
  type        = string
  description = "AWS region"
}

variable "aws_account_id" {
  type        = string
  description = "AWS account ID"
}

