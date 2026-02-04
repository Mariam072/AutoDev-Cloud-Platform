#################################
# VPC
#################################
module "vpc" {
  source = "./modules/vpc"

  env                  = var.env
  vpc_cidr             = var.vpc_cidr
  public_subnet_count  = var.public_subnet_count
  private_subnet_count = var.private_subnet_count
}

#################################
# EKS
#################################
module "eks" {
  source = "./modules/eks"

  env                        = var.env
  cluster_name               = var.cluster_name
  vpc_id                     = module.vpc.vpc_id
  private_subnets             = module.vpc.private_subnets

  node_group_instance_type   = var.node_group_instance_type
  node_group_desired_size    = var.node_group_desired_size
  node_group_min_size        = var.node_group_min_size
  node_group_max_size        = var.node_group_max_size
}

#################################
# ECR
#################################
module "ecr" {
  source = "./modules/ecr"

  env = var.env
}

#################################
# Cognito
#################################
module "cognito" {
  source = "./modules/cognito"

  env    = var.env
  region = var.aws_region
}

#################################
# API Gateway + VPC Link
#################################
module "api_gateway" {
  source = "./modules/api_gateway"

  env                 = var.env
  region              = var.aws_region

  vpc_id              = module.vpc.vpc_id
  private_subnets     = module.vpc.private_subnets

  user_pool_id        = module.cognito.user_pool_id
  user_pool_client_id = module.cognito.user_pool_client_id
}
