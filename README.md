# Elastic Kubernetes Service (EKS)

This is an opinionated terraform module to bootstrap an EKS Cluster using Terraform.

Features enabled:

* Logging using Amazon Cloudwatch

* Firewall security measures, allowing only required control-plane to nodes communication.

* IAM Accounts for Service Accounts

* VPC Native cluster

* Cluster Autoscaler IAM Roles and Helm release installed (configurable)

* Metrics server configured and fully functional

* Updatable nodes through AWS Autoscaling instance refreshes

* Non-default SA for nodes

* Usage of containerd as runtime (configurable on the example file)

* `aws-auth` management

## Usage

You can find a fully functional, production-ready example on the `examples/` folder.

### Requirements

| Name | Version |
| --------- | ------- |
| terraform | >= 1.0 |

### Important Note

This module requires the `kubectl` client to be installed, since it uses a local exec provisioner.

### Providers

| Name | Version |
| ----------- | -------- |
| local | ~> 2.4.0 |
| aws | ~> 5.13.1 |
| kubernetes | ~> 2.23.0 |
| null | >= 3.2.1 |
| helm | 2.10.1 |

### Inputs

| Name                      | Description                                                                                                                                        | Type                                                                                            | Default                                             | Required |
|---------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------|-----------------------------------------------------|----------|
| environment               | The environment where this cluster will be deployed. All names will be generated from this variable                                                | string                                                                                          | initializ-sandbox                                        | no       |
| kubernetes_version        | The Kubernetes version that the module will try to bootstrap                                                                                       | string                                                                                          | 1.27                                                | no       |
| self_managed_node_groups  | An object representing all node-groups that you want to create. They should be generated according the terraform-aws-modules/eks/aws documentation | any                                                                                             | n/a                                                 | yes      |
| vpc_cidr                  | VPC's CIDR to be created by the VPC module                                                                                                         | string                                                                                          | 10.0.0.0/16                                         | no       |
| vpc_private_subnets       | VPC's private subnets to be created by the VPC module                                                                                              | list(string)                                                                                    | [ "10.0.1.0/24" ,  "10.0.2.0/24" ,  "10.0.3.0/24" ] | no       |
| vpc_public_subnets        | VPC's public subnets to be created by the VPC module                                                                                               | list(string)                                                                                    | [ "10.0.4.0/24" ,  "10.0.5.0/24" ,  "10.0.6.0/24" ] | no       |
| enable_cluster_autoscaler | Whether to create a Helm release installing cluster-autoscaler resources or not                                                                    | bool                                                                                            | false                                               | no       |
| create_aws_auth_configmap | This option toogles aws-auth creation. It should only be enabled when using self-managed nodes                                                                    | bool                                                                                            | false                                               | no       |
| control_plane_public_access | Indicates whether or not the Amazon EKS public API server endpoint is enabled                                                                    | bool                                                                                            | false                                               | no       |
| kms_key_administrators        | A list of IAM ARNs for key administrators                                                                                               | list(string)                                                                                    | n/a                       | yes       |
| map_users                 | An array of objects that represent what IAM users have access to the EKS Cluster                                                                   | list(object({     userarn  =  string     username =  string     groups   = list( string )   })) | []                                                  | no       |
| map_roles                 | An array of objects that represent what IAM roles have access to the EKS Cluster                                                                   | list(object({     rolearn  =  string     username =  string     groups   = list( string )   })) | []                                                  | no       |

### Outputs

| Name                     | Description                  |
| ------------------------ | ---------------------------- |
| cluster_arn              | The Amazon Resource Name (ARN) of the cluster             |
| cluster_certificate_authority_data           | Base64 encoded certificate data required to communicate with the cluster |
| cluster_endpoint              | Endpoint for your Kubernetes API server        |
| cluster_id             | The name/id of the EKS cluster. Will block on cluster creation until the cluster is really ready                 |
| cluster_name             | The name of the EKS cluster. Will block on cluster creation until the cluster is really ready                 |
| cluster_oidc_issuer_url        | The URL on the EKS cluster for the OpenID Connect identity provider             |
| oidc_provider_arn          | The ARN of the OIDC Provider              |
| cloudwatch_log_group_name          | Name of cloudwatch log group created              |
| cloudwatch_log_group_arn          | Arn of cloudwatch log group created              |
| self_managed_node_groups_autoscaling_group_names | The names of the self managed ASG created by the module |
