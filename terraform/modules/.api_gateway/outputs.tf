output "api_gateway_invoke_url" {
  description = "Invoke URL of the API Gateway stage"
  value       = "https://${aws_api_gateway_rest_api.api.id}.execute-api.${var.aws_region}.amazonaws.com/${aws_api_gateway_stage.stage_name}"
}

output "vpc_link_id" {
  description = "ID of the created VPC Link"
  value       = aws_api_gateway_vpc_link.vpc_link.id
}
