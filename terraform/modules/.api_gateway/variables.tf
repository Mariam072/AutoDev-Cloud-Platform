variable "env" {
  description = "Environment name (prod/nonprod)"
  type        = string
}

variable "region" {
  type = string
}

variable "user_pool_id" {
  type = string
}

variable "user_pool_client_id" {
  type = string
}