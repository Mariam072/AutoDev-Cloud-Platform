
# VPC
module "vpc" {
  source   = "./modules/vpc"
  vpc_cidr = var.vpc_cidr
  env      = var.env
}

# Subnets
module "subnets" {
  source   = "./modules/subnets"
  vpc_id   = module.vpc.vpc_id
  azs      = var.azs
  env      = var.env
}

# Routing (IGW + NAT + Route Tables)
module "routing" {
  source             = "./modules/routing"
  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.subnets.public_subnet_ids
  private_subnet_ids = module.subnets.private_subnet_ids
  env                = var.env
}

module "cognito" {
  source = "./modules/cognito"
  env    = var.env
}

module "api_gateway" {
  source = "./modules/api_gateway"

  env                  = var.env
  region               = var.aws_region
  user_pool_id         = module.cognito.user_pool_id
  user_pool_client_id  = module.cognito.user_pool_client_id
}

#IAM Role
module "iam" {
  source = "./modules/iam"
  env    = var.env
}

# EKS Cluster
module "eks" {
  source = "./modules/eks"

  env                = var.env
  cluster_version    = var.cluster_version
  vpc_id             = module.vpc.vpc_id
 private_subnet_ids = module.subnets.private_subnet_ids
 iam_role= module.iam.eks_node_role_arn
 #key_name        = var.key_name
  instance_types  = var.instance_types

  node_min     = var.node_min
  node_max     = var.node_max
  node_desired = var.node_desired
}
