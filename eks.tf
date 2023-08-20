data "aws_availability_zones" "available" {}

data "aws_eks_cluster" "cluster" {
  name = module.eks_cluster.cluster_name
}

data "aws_eks_cluster_auth" "this" {
  name = module.eks_cluster.cluster_name
}

module "eks_cluster" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.16.0"

  cluster_name    = local.cluster_name
  cluster_version = var.kubernetes_version

  cluster_enabled_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  manage_aws_auth_configmap = var.manage_aws_auth_configmap
  create_aws_auth_configmap = var.create_aws_auth_configmap
  cluster_endpoint_public_access = var.control_plane_public_access
  aws_auth_roles = var.map_roles
  aws_auth_users = var.map_users

  # # Enabling encryption on AWS EKS secrets using a customer-created key
  create_kms_key = false
  cluster_encryption_config = {
    resources        = ["secrets"]
    provider_key_arn = module.kms.key_arn
  }


  # Enabling this, we allow EKS to manage this components for us (upgrading and maintaining)
  cluster_addons = {
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  # IRSA enabled to create an OpenID trust between our cluster and IAM, in order to map AWS Roles to Kubernetes SA's
  enable_irsa = true

  self_managed_node_group_defaults = {
    update_launch_template_default_version = true
    iam_role_additional_policies           = {
        AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
      }
  }


  self_managed_node_groups = var.self_managed_node_groups

  node_security_group_additional_rules = {

    ms_443_ing = {
      description                   = "Cluster API to metrics server 15017 ingress port"
      protocol                      = "tcp"
      from_port                     = 15017
      to_port                       = 15017
      type                          = "ingress"
      source_cluster_security_group = true
    }
    node_to_node_eg = {
      description = "Node to node egress traffic"
      from_port   = 1
      to_port     = 65535
      protocol    = "all"
      type        = "egress"
      self        = true
    }
  }

}
