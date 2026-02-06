variable "env" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "private_subnets" {
  type = list(string)
}

variable "node_group_instance_type" {
  type = string
}

variable "node_group_desired_size" {
  type = number
}

variable "node_group_min_size" {
  type = number
}

variable "node_group_max_size" {
  type = number
}
