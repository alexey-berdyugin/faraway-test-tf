terraform {
  required_version = ">= 1.13.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.14.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.0.2"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.38"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "private"
}

data "terraform_remote_state" "eks" {
  backend = "s3"

  config = {
    bucket = "berdyugin-faraway-test-tf-state"
    key    = "envs/dev/eks/terraform.tfstate"
    region = "us-east-1"
  }
}

data "aws_eks_cluster" "cluster" {
  name = "dev-eks"
}

data "aws_eks_cluster_auth" "cluster" {
  name = "dev-eks"
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}

resource "helm_release" "nginx" {
  name       = "test-nginx-app"
  repository = "https://github.com/alexey-berdyugin/faraway-test-helm-chart"
  chart      = "test-nginx-app"
  version    = "0.1.0"

  namespace = "default"

  values = []
}
