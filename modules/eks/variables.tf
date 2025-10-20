variable "region" {
  type        = string
  description = "AWS region where the EKS cluster will be deployed"
}

variable "profile" {
  type        = string
  description = "AWS CLI profile to use"
  default     = "private"
}

variable "cluster_name" {
  type        = string
  description = "Name of the EKS cluster"
}

variable "cluster_version" {
  type        = string
  default     = "1.34"
  description = "Kubernetes version for the EKS cluster"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where EKS will be deployed"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnets used by the EKS cluster"
}

variable "project_name" {
  type        = string
  description = "Name of the project"
  default     = "Faraway"
}

variable "environment" {
  type        = string
  description = "Environment (e.g. dev, stage, prod)"
}

variable "additional_tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags for all resources"
}

variable "enable_karpenter" {
  type    = bool
  default = true
}

variable "alb_namespace" {
  type    = string
  default = "kube-system"
}
