terraform {
  required_version = ">= 1.13.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.14.0"
    }
  }
}

provider "aws" {
  region  = var.region
  profile = var.profile
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids

  # IRSA (recommended)
  enable_irsa = true

  # Cluster endpoint configuration
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  # Manage node security groups
  manage_aws_auth_configmap = true

  # Karpenter submodule
  karpenter = {
    enable = var.enable_karpenter

    name = "${var.cluster_name}-karpenter"

    namespace = "karpenter"

    # Use default IAM role and service account if not provided
    create_iam_role = true

    # Optionally pass a custom trust policy or assume role
    iam_role_name = "${var.cluster_name}-karpenter-role"

    # Configure node IAM policy attachment
    iam_role_additional_policies = [
      "arn:aws:iam::aws:policy/AmazonEC2FullAccess",
      "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    ]

    # Karpenter default node labels
    node_labels = {
      "karpenter.sh/discovery" = var.cluster_name
      "environment"            = var.environment
    }

    # Optionally customize service account
    service_account_name      = "karpenter"
    service_account_namespace = "karpenter"
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
