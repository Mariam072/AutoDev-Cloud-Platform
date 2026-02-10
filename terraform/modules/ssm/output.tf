output "mongo_uri_ssm_name" {
  value = aws_ssm_parameter.mongo_uri.name
}
