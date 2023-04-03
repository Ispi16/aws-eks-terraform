data "tls_certificate" "eks_oidc" {
  url = local.oidc_url
}

resource "aws_iam_openid_connect_provider" "eks_oidc" {
  count = var.create_oidc_provider ? 1 : 0
  url   = local.oidc_url

  client_id_list = [
    "sts.amazonaws.com",
  ]

  thumbprint_list = [
    local.thumbprint
  ]
}
