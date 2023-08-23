## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_local"></a> [local](#provider\_local) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_access_key.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_access_key) | resource |
| [aws_iam_policy.azuread_list_roles](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.azure_ad_federation_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.azure_ad_role_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_saml_provider.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_saml_provider) | resource |
| [aws_iam_user.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_user_policy_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy_attachment) | resource |
| [aws_kms_alias.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_secretsmanager_secret.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_version.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_ssm_parameter.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_caller_identity.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.azure_saml_trusted_entities](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_region.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [local_file.this](https://registry.terraform.io/providers/hashicorp/local/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_Azure_AD_SSO_Roles"></a> [Azure\_AD\_SSO\_Roles](#input\_Azure\_AD\_SSO\_Roles) | List of IAM Roles to be created. These roles will be federated wih Azure AD SAML 2.0 Auth | <pre>list(object({<br>    name                           = string<br>    policy_arns                    = list(string)<br>    permission_boundary_policy_arn = string<br>  }))</pre> | `[]` | no |
| <a name="input_additional_tags"></a> [additional\_tags](#input\_additional\_tags) | Tags as Key/Value pair map. These tags are attached all the resources created by module | `map(string)` | `{}` | no |
| <a name="input_azure_ad_provisioner_user"></a> [azure\_ad\_provisioner\_user](#input\_azure\_ad\_provisioner\_user) | IAM user to create for Azure AD SSO provisioning, If not specified user will be auto generated | `string` | `""` | no |
| <a name="input_enable_kms_key_rotation"></a> [enable\_kms\_key\_rotation](#input\_enable\_kms\_key\_rotation) | Specifies whether KMS key rotation is enabled | `bool` | `true` | no |
| <a name="input_kms_description"></a> [kms\_description](#input\_kms\_description) | The description of the KMS key as viewed in AWS console | `string` | `"SSM Parameter Store KMS master key used for AzureAD user secret"` | no |
| <a name="input_kms_key_deletion_days"></a> [kms\_key\_deletion\_days](#input\_kms\_key\_deletion\_days) | Duration in days after which the key is deleted after destruction of the resource | `number` | `10` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace used as one of the combination for tags prefix. Usually goes to Name tag | `string` | `"example"` | no |
| <a name="input_pgp_key_file"></a> [pgp\_key\_file](#input\_pgp\_key\_file) | PGP key file path to encrypt the AzureAD user secret\_access\_key, so that state file will not save them in plain text | `string` | n/a | yes |
| <a name="input_saml_audience"></a> [saml\_audience](#input\_saml\_audience) | SAML Audience, default is https://signin.aws.amazon.com/saml, You should override this, if you have multiple accounts provisioned from SSO provider | `string` | `"https://signin.aws.amazon.com/saml"` | no |
| <a name="input_saml_xml_file_path"></a> [saml\_xml\_file\_path](#input\_saml\_xml\_file\_path) | An XML document generated by an identity provider that supports SAML 2.0 | `string` | n/a | yes |
| <a name="input_stage"></a> [stage](#input\_stage) | Stage used as one of the combination for tags prefix. Usually goes to Name tag and helps identify environment. Default is set to `dev` | `string` | `"dev"` | no |
| <a name="input_use_ssm_store_sso_secrets"></a> [use\_ssm\_store\_sso\_secrets](#input\_use\_ssm\_store\_sso\_secrets) | When set to true, SSM parameter store will be used for storing the secrets for AzureAD user instead of secrets manager | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_AzureADProvisionerUser"></a> [AzureADProvisionerUser](#output\_AzureADProvisionerUser) | IAM User created Azure AD Provisioning |
| <a name="output_AzureADSSORoles"></a> [AzureADSSORoles](#output\_AzureADSSORoles) | List of IAM Roles created and associated with Azure AD SAML 2.0 identity federation |
| <a name="output_AzureAD_IAM_User_Secret"></a> [AzureAD\_IAM\_User\_Secret](#output\_AzureAD\_IAM\_User\_Secret) | Map {store : "<SSM/SecretManager>", arn : "<arn\_of\_secret\_store>"}, indicating store type and arn |
