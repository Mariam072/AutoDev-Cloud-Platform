resource "aws_ssm_parameter" "mongo_uri" {
  name        = "/${var.env}/mongoUri"
  description = "MongoDB URI for ${var.env} environment"
  type        = "SecureString"
  value       = var.mongo_uri
  overwrite   = true
}
