data "tls_certificate" "oidc" {
  url = var.oidc_issuer
}

resource "aws_iam_openid_connect_provider" "this" {
  url             = var.oidc_issuer
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.oidc.certificates[0].sha1_fingerprint]
}

resource "aws_iam_role" "irsa_generic" {
  name = "${var.cluster_name}-irsa-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Federated = aws_iam_openid_connect_provider.this.arn
      }
      Action = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringLike = {
          "${replace(var.oidc_issuer, "https://", "")}:sub" = "system:serviceaccount:*:*"
        }
      }
    }]
  })
}
