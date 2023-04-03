locals {
  oidc_url        = aws_eks_cluster.eks_cluster.identity.0.oidc.0.issuer
  thumbprint      = data.tls_certificate.eks_oidc.certificates.0.sha1_fingerprint
}
