#################################
# VPC
#################################
module "vpc" {
  source               = "./modules/vpc"
  env                  = var.env
  vpc_cidr             = var.vpc_cidr
  public_subnet_count  = var.public_subnet_count
  private_subnet_count = var.private_subnet_count
}

#################################
# EKS
#################################

data "aws_caller_identity" "current" {}

module "iam" {
  source         = "./modules/iam"
  cluster_name   = var.cluster_name
  env            = var.env
  aws_account_id = data.aws_caller_identity.current.account_id
}

module "eks" {
  source = "./modules/eks"

  env              = var.env
  cluster_name     = var.cluster_name
  vpc_id           = module.vpc.vpc_id
  private_subnets  = module.vpc.private_subnet_ids

  cluster_role_arn = module.iam.cluster_role_arn
  node_role_arn    = module.iam.node_role_arn

  node_group_instance_type = var.node_group_instance_type
  node_group_desired_size  = var.node_group_desired_size
  node_group_min_size      = var.node_group_min_size
  node_group_max_size      = var.node_group_max_size
}

module "irsa" {
  source        = "./modules/irsa"
  cluster_name  = var.cluster_name
  oidc_issuer   = module.eks.cluster_oidc_issuer
  env           = var.env
}


#################################
# ECR
#################################
module "ecr" {
  source = "./modules/ecr"
  env    = var.env
}

#################################
# Cognito
#################################
module "cognito" {
  source = "./modules/cognito"
  env    = var.env

}

#################################
# NLB
#################################
module "nlb" {
  source          = "./modules/nlb"
  env             = var.env
  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnet_ids
}


}
#################################
# nlb
#################################
module "nlb" {
  source           = "./modules/nlb"
  env              = var.env
  vpc_id           = module.vpc.vpc_id
  private_subnets  = module.vpc.private_subnet_ids
}


#################################
# API Gateway + VPC Link
#################################
module "api_gateway" {
  source = "./modules/api_gateway"

  env                 = var.env
  region              = var.aws_region
  user_pool_id        = module.cognito.user_pool_id
  user_pool_client_id = module.cognito.user_pool_client_id
  nlb_listener_arn    = module.nlb.listener_arn
  private_subnets     = module.vpc.private_subnet_ids
  vpc_id              = module.vpc.vpc_id

}
