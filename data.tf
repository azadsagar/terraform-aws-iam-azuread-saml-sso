

data "aws_caller_identity" "this" {}
data "aws_region" "this" {}
data "aws_partition" "current" {}

data "local_file" "this" {
  filename = abspath(var.pgp_key_file)
}


data "aws_iam_policy_document" "azure_saml_trusted_entities" {
  count      = length(var.Azure_AD_SSO_Roles) == 0 ? 0 : 1
  depends_on = [aws_iam_saml_provider.this]
  version    = "2012-10-17"
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithSAML"]
    principals {
      identifiers = [aws_iam_saml_provider.this.arn]
      type        = "Federated"
    }
    condition {
      test     = "StringEquals"
      values   = [var.saml_audience]
      variable = "SAML:aud"
    }
  }
}