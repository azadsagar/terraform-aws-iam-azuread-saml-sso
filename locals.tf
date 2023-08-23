locals {
  tag_prefix    = "${var.namespace}-${var.stage}"
  azure_ad_user = length(var.azure_ad_provisioner_user) == 0 ? "${var.namespace}${var.stage}AzureADProv" : var.azure_ad_provisioner_user

  ad_role_polocy_attachments = flatten([
    for item in var.Azure_AD_SSO_Roles : [
      for policy in item.policy_arns : {
        name   = item.name
        policy = policy
      }
    ]
  ])
}