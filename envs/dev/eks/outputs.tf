output "cluster_name" {
  value       = module.eks.cluster_name
  description = "EKS cluster name"
}

output "cluster_endpoint" {
  value       = module.eks.cluster_endpoint
  description = "EKS API server endpoint"
}

output "cluster_security_group_id" {
  value       = module.eks.cluster_security_group_id
  description = "EKS cluster security group ID"
}

output "karpenter_iam_role_arn" {
  value       = module.eks.karpenter_iam_role_arn
  description = "IAM role ARN created for Karpenter"
}

output "node_iam_role_arn" {
  value       = module.eks.node_iam_role_arn
  description = "IAM role ARN created for Karpenter"
}

output "oidc_provider_arn" {
  value       = module.eks.oidc_provider_arn
  description = "OIDC provider ARN for IRSA"
}
