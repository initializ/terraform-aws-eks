module "eks-cluster" {
  source             = "../."
  environment        = "eks-np"
  kubernetes_version = "1.27"

  enable_cluster_autoscaler = true

  # Networking configuration 
  vpc_cidr            = "10.0.0.0/16"
  vpc_private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  vpc_public_subnets  = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]


  create_aws_auth_configmap = true

  map_users = [
    {
      userarn  = "arn:aws:iam::596821251520:user/ekscluster-user"
      username = "ekscluster-user"
    }
  ]

  map_roles = [
    {
      rolearn  = "https://ap-south-1.console.aws.amazon.com/iam/home#/roles/eks_cluster_role"
      username = "eks_cluster_role"
    }
  ]

  # Here, we define all node pools that we want to create

eks_managed_node_group {
  source = "../."

  name            = "initialize_NP_Dev_NodeGroup"
  cluster_name    = "initializ_NP_EKS_1"
  cluster_version = "1.27"

  subnet_ids = ["subnet-0501d64a655aa4bf4", "subnet-0abfb59bfe6b60a87", "subnet-098961aaf3d3dbf13"]


  min_size     = 3
  max_size     = 3
  desired_size = 3

  instance_types = ["t3a.medium"]
  capacity_type  = "On-Demand"

}
 

    
  
}
