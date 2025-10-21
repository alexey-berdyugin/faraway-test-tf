module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = var.cluster_name
  kubernetes_version = var.cluster_version

  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids

  # IRSA (recommended)
  enable_irsa = true

  # Cluster endpoint configuration
  endpoint_private_access = true
  endpoint_public_access  = true

  eks_managed_node_groups = {
    initial = {
      instance_types = ["t3.small"]

      min_size     = 1
      max_size     = 2
      desired_size = 1
    }
  }

  tags = merge(
    {
      "Project"     = var.project_name
      "Environment" = var.environment
      "ManagedBy"   = "Terraform"
    },
    var.additional_tags
  )
}

module "eks-aws-auth" {
  source  = "terraform-aws-modules/eks/aws//modules/aws-auth"
  version = "~> 20.37"

  manage_aws_auth_configmap = true
  aws_auth_users            = var.allowed_users
  # aws_auth_roles = var.allowed_roles

  aws_auth_roles = concat(var.allowed_roles, [
    {
      rolearn  = module.karpenter.iam_role_arn
      username = "karpenter"
      groups   = ["system:node-proxier"]
    }
  ])
}

# Kube-proxy
resource "aws_eks_addon" "kube_proxy" {
  cluster_name                = var.cluster_name
  addon_name                  = "kube-proxy"
  addon_version               = "v1.34.0-eksbuild.2"
  resolve_conflicts_on_create = "OVERWRITE"
}

# CoreDNS
resource "aws_eks_addon" "coredns" {
  cluster_name                = var.cluster_name
  addon_name                  = "coredns"
  addon_version               = "v1.12.3-eksbuild.1"
  resolve_conflicts_on_create = "OVERWRITE"
}

# VPC CNI
resource "aws_eks_addon" "vpc_cni" {
  cluster_name                = var.cluster_name
  addon_name                  = "vpc-cni"
  addon_version               = "v1.20.4-eksbuild.1"
  resolve_conflicts_on_create = "OVERWRITE"
}
