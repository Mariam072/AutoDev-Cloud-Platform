#output "vpc_id" {
#  value = module.vpc.vpc_id
#}

#output "public_subnets" {
#  value = module.subnets.public_subnet_ids
#}

#output "private_subnets" {
#  value = module.subnets.private_subnet_ids
#}

#output "igw_id" {
#  value = module.routing.igw_id
#}

#output "nat_ids" {
#  value = module.routing.nat_ids
#}

#output "eks_cluster_name" {
#  value = module.eks.cluster_name
#}
output "api_endpoint" {
  value = module.api_gateway.api_endpoint
}

output "vpc_link_id" {
  value = module.api_gateway.vpc_link_id
}

output "cluster_name" {
  value = module.eks.cluster_name
}


output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "irsa_role_arn" {
  value = module.irsa.irsa_role_arn
}

output "ecr_repository_url" {
  value = module.ecr.repository_url
}

output "mongo_uri_ssm_name" {
  value = module.ssm.mongo_uri_ssm_name
}
output "cognito_user_pool_client_id" {
  description = "The Cognito User Pool Client ID"
  value       = module.cognito.user_pool_client_id
}
output "cognito_user_pool_id" {
  description = "The Cognito User Pool ID"
  value       = module.cognito.user_pool_id
}
