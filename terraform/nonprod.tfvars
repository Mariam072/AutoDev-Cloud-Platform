# Environment
env = "nonprod"

# AWS
aws_region = "eu-west-1"

# EKS
cluster_name = "nonprod-eks-cluster"

# VPC
vpc_cidr = "10.1.0.0/16"

public_subnet_count  = 2
private_subnet_count = 2

# Node Group
node_group_instance_type = "t3.small"

node_group_desired_size = 1
node_group_min_size     = 1
node_group_max_size     = 2
