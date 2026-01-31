# =========================
# API Gateway REST API
# =========================
resource "aws_api_gateway_rest_api" "api" {
  name        = "api-${var.env}"
  description = "API Gateway for ${var.env} environment"
}

# =========================
# Example Resource Path
# =========================
resource "aws_api_gateway_resource" "example" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "example"
}

# =========================
# GET Method
# =========================
resource "aws_api_gateway_method" "get_example" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.example.id
  http_method   = "GET"
  authorization = "NONE"
}

# =========================
# VPC Link Integration
# =========================
resource "aws_api_gateway_integration" "example" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.example.id
  http_method             = aws_api_gateway_method.get_example.http_method
  type                    = "HTTP_PROXY"
  connection_type         = "VPC_LINK"
  connection_id           = aws_api_gateway_vpc_link.vpc_link.id
  uri                     = var.backend_uri
  integration_http_method = "GET"
}

# =========================
# VPC Link to Internal LB
# =========================
resource "aws_api_gateway_vpc_link" "vpc_link" {
  name        = "vpc-link-${var.env}"
  target_arns = var.lb_arns
}

# =========================
# Deployment
# =========================
resource "aws_api_gateway_deployment" "deployment" {
  depends_on  = [aws_api_gateway_integration.example]
  rest_api_id = aws_api_gateway_rest_api.api.id
}

# =========================
# Stage
# =========================
resource "aws_api_gateway_stage" "stage" {
  stage_name    = var.env
  rest_api_id   = aws_api_gateway_rest_api.api.id
  deployment_id = aws_api_gateway_deployment.deployment.id
}
