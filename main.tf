
resource "aws_iam_user" "this" {
  name = local.azure_ad_user
}

resource "aws_iam_policy" "azuread_list_roles" {
  name = "${local.tag_prefix}-azuread-list-roles"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "iam:ListRoles"
        ]
        Resource = "*"
      }
    ]
  })
  path = "/"

  tags = merge({
    Name = "${local.tag_prefix}-azuread-list-roles"
  }, var.additional_tags)
}

resource "aws_iam_access_key" "this" {
  user    = aws_iam_user.this.name
  pgp_key = data.local_file.this.content_base64
}

resource "aws_iam_user_policy_attachment" "this" {
  policy_arn = aws_iam_policy.azuread_list_roles.arn
  user       = aws_iam_user.this.name
}

resource "aws_kms_key" "this" {
  deletion_window_in_days  = var.kms_key_deletion_days
  enable_key_rotation      = var.enable_kms_key_rotation
  description              = "KMS key used to encrypt secrets generated for azure ad user"
  key_usage                = "ENCRYPT_DECRYPT"
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  multi_region             = false

  tags = merge({
    Name = "alias/${var.namespace}/${var.stage}/azuread/user/secrets"
  }, var.additional_tags)
}

resource "aws_kms_alias" "this" {
  target_key_id = aws_kms_key.this.id
  name          = "alias/${var.namespace}/${var.stage}/azuread/user/secrets"
}

resource "aws_ssm_parameter" "this" {
  count  = var.use_ssm_store_sso_secrets ? 1 : 0
  name   = "/${var.namespace}/${var.stage}/azuread/user/secrets"
  type   = "SecureString"
  key_id = aws_kms_key.this.arn
  value = jsonencode({
    access_key_id     = aws_iam_access_key.this.id
    secret_access_key = aws_iam_access_key.this.encrypted_secret
  })

  tags = merge({
    Name = "/${var.namespace}/${var.stage}/azuread/user/secrets"
  }, var.additional_tags)
}

resource "aws_secretsmanager_secret" "this" {
  count      = var.use_ssm_store_sso_secrets ? 0 : 1
  kms_key_id = aws_kms_key.this.id
  name       = "/${var.namespace}/${var.stage}/azuread/user/secrets"

  description = "AzureAD user secrets"

  tags = merge({
    Name = "/${var.namespace}/${var.stage}/azuread/user/secrets"
  }, var.additional_tags)
}

resource "aws_secretsmanager_secret_version" "this" {
  count     = var.use_ssm_store_sso_secrets ? 0 : 1
  secret_id = element(aws_secretsmanager_secret.this.*.id, count.index)
  secret_string = jsonencode({
    access_key_id     = aws_iam_access_key.this.id
    secret_access_key = aws_iam_access_key.this.encrypted_secret
  })
}

resource "aws_iam_saml_provider" "this" {
  name                   = "${local.tag_prefix}-AzureAD"
  saml_metadata_document = file(var.saml_xml_file_path)
}

resource "aws_iam_role" "azure_ad_federation_role" {
  count              = length(var.Azure_AD_SSO_Roles)
  name               = var.Azure_AD_SSO_Roles[count.index].name
  assume_role_policy = element(data.aws_iam_policy_document.azure_saml_trusted_entities.*.json, 0)

  permissions_boundary = var.Azure_AD_SSO_Roles[count.index].permission_boundary_policy_arn == "" ? null : var.Azure_AD_SSO_Roles[count.index].permission_boundary_policy_arn
}

resource "aws_iam_role_policy_attachment" "azure_ad_role_policy_attachment" {
  depends_on = [aws_iam_role.azure_ad_federation_role]
  count      = length(local.ad_role_polocy_attachments)

  role       = local.ad_role_polocy_attachments[count.index].name
  policy_arn = local.ad_role_polocy_attachments[count.index].policy
}