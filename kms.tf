module "kms" {
  source = "terraform-aws-modules/kms/aws"
  version = "~> 1.5.0"

  description             = "KMS Key generated to encrypt ${local.cluster_name} secrets"
  deletion_window_in_days = 10
  enable_key_rotation     = true
  key_administrators      = var.kms_key_administrators
}
