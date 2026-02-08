variable "env" {}
variable "cluster_name" {}
variable "vpc_id" {}
variable "private_subnets" {}
variable "node_group_instance_type" {}
variable "node_group_desired_size" {}
variable "node_group_min_size" {}
variable "node_group_max_size" {}
variable "cluster_role_arn" {}
variable "node_role_arn" {}
variable "target_port" {}
variable "nlb_sg_id" {} # id of the NLB SG
