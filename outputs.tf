

output "AzureADProvisionerUser" {
  value = aws_iam_user.this.name
  description = "IAM User created Azure AD Provisioning"
}

output "AzureADSSORoles" {
  value = aws_iam_role.azure_ad_federation_role.*.arn
  description = "List of IAM Roles created and associated with Azure AD SAML 2.0 identity federation"
}

output "AzureAD_IAM_User_Secret" {
  value = {
    store = var.use_ssm_store_sso_secrets ? "SSM" : "SecretManager"
    arn = var.use_ssm_store_sso_secrets ? aws_ssm_parameter.this[0].arn : aws_secretsmanager_secret.this[0].arn
  }

  description = "Map {store : \"<SSM/SecretManager>\", arn : \"<arn_of_secret_store>\"}, indicating store type and arn "
}