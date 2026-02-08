env                      = "prod"
aws_region               = "eu-west-1"
cluster_name             = "prod-eks-cluster"

vpc_cidr                 = "10.0.0.0/16"


public_subnet_count      = 2
private_subnet_count     = 2


node_group_instance_type = "t3.small"
node_group_desired_size  = 1
node_group_min_size      = 1
node_group_max_size      = 2

nlb_listener_port        = 80
nlb_target_port          = 30080
