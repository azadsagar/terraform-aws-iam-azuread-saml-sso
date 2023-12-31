
variable "namespace" {
  type        = string
  default     = "example"
  description = "Namespace used as one of the combination for tags prefix. Usually goes to Name tag"
}

variable "stage" {
  type        = string
  default     = "dev"
  description = "Stage used as one of the combination for tags prefix. Usually goes to Name tag and helps identify environment. Default is set to `dev`"
}

variable "use_ssm_store_sso_secrets" {
  type        = bool
  default     = false
  description = "When set to true, SSM parameter store will be used for storing the secrets for AzureAD user instead of secrets manager"
}

variable "additional_tags" {
  type        = map(string)
  default     = {}
  description = "Tags as Key/Value pair map. These tags are attached all the resources created by module"
}

variable "kms_key_deletion_days" {
  type        = number
  default     = 10
  description = "Duration in days after which the key is deleted after destruction of the resource"
}

variable "enable_kms_key_rotation" {
  type        = bool
  default     = true
  description = "Specifies whether KMS key rotation is enabled"
}

variable "kms_description" {
  type        = string
  default     = "SSM Parameter Store KMS master key used for AzureAD user secret"
  description = "The description of the KMS key as viewed in AWS console"
}

variable "azure_ad_provisioner_user" {
  type        = string
  default     = ""
  description = "IAM user to create for Azure AD SSO provisioning, If not specified user will be auto generated"
}

variable "pgp_key_file" {
  type        = string
  description = "PGP key file path to encrypt the AzureAD user secret_access_key, so that state file will not save them in plain text"
}

variable "saml_xml_file_path" {
  type        = string
  description = "An XML document generated by an identity provider that supports SAML 2.0"
}

variable "saml_audience" {
  type        = string
  default     = "https://signin.aws.amazon.com/saml"
  description = "SAML Audience, default is https://signin.aws.amazon.com/saml, You should override this, if you have multiple accounts provisioned from SSO provider"
}


variable "Azure_AD_SSO_Roles" {
  type = list(object({
    name                           = string
    policy_arns                    = list(string)
    permission_boundary_policy_arn = string
  }))

  default = []

  description = "List of IAM Roles to be created. These roles will be federated wih Azure AD SAML 2.0 Auth"
}