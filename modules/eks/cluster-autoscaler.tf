# -----------------------------------------------------------------------------
# Cluster Autoscaler Helm chart
# -----------------------------------------------------------------------------
resource "helm_release" "cluster_autoscaler" {
  name       = "cluster-autoscaler"
  namespace  = "kube-system"
  repository = "https://kubernetes.github.io/autoscaler"
  chart      = "cluster-autoscaler"
  version    = "9.52.1" # Check for the latest version compatible with your K8s version

  # You can use IRSA (recommended) or manually assign AWS credentials to the pod
  values = [
    yamlencode({
      autoDiscovery = {
        clusterName = module.eks.cluster_name
      }

      awsRegion = var.region

      rbac = {
        serviceAccount = {
          create = true
          name   = "cluster-autoscaler"
          annotations = {
            "eks.amazonaws.com/role-arn" = aws_iam_role.cluster_autoscaler.arn
          }
        }
      }

      extraArgs = {
        "skip-nodes-with-system-pods"   = false
        "balance-similar-node-groups"   = true
        "skip-nodes-with-local-storage" = false
        "stderrthreshold"               = "info"
      }

      replicaCount = 1
    })
  ]

  depends_on = [aws_iam_role.cluster_autoscaler]
}

resource "aws_iam_role" "cluster_autoscaler" {
  name = "eks-cluster-autoscaler-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = module.eks.oidc_provider_arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "${replace(module.eks.cluster_oidc_issuer_url, "https://", "")}:sub" = "system:serviceaccount:kube-system:cluster-autoscaler"
            "${replace(module.eks.cluster_oidc_issuer_url, "https://", "")}:aud" = "sts.amazonaws.com"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cluster_autoscaler_policy" {
  role       = aws_iam_role.cluster_autoscaler.name
  policy_arn = "arn:aws:iam::aws:policy/AutoScalingFullAccess"
}
