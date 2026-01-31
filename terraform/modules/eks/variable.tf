variable "env" {
  type        = string
  description = "Environment name"
}

variable "cluster_version" {
  type        = string
  default     = "1.27"
}

variable "vpc_id" {
  type        = string
}

variable "private_subnet_ids" {
  type        = list(string)
}

#variable "key_name" {
#  type        = string
#}

variable "instance_types" {
  type        = list(string)
}

variable "node_min" {
  type = number
}

variable "node_max" {
  type = number
}

variable "node_desired" {
  type = number
}
variable "iam_role"{

}
  
