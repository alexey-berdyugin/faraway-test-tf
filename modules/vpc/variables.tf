variable "region" {
  type        = string
  description = "AWS region to deploy the VPC"
}

variable "vpc_name" {
  type        = string
  description = "Name of the VPC"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
}

variable "azs" {
  type        = list(string)
  description = "List of availability zones"
}

variable "private_subnets" {
  type        = list(string)
  description = "List of private subnet CIDRs"
}

variable "public_subnets" {
  type        = list(string)
  description = "List of public subnet CIDRs"
}

variable "enable_nat_gateway" {
  type        = bool
  default     = true
  description = "Whether to enable NAT gateways"
}

variable "single_nat_gateway" {
  type        = bool
  default     = true
  description = "Use a single NAT Gateway across all AZs"
}

variable "enable_dns_hostnames" {
  type        = bool
  default     = true
  description = "Enable DNS hostnames for VPC"
}

variable "project_name" {
  type        = string
  description = "Project name"
  default     = "Faraway"
}

variable "environment" {
  type        = string
  description = "Deployment environment (e.g., dev, stage, prod)"
}

variable "additional_tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags to apply to resources"
}

variable "profile" {
  type    = string
  default = "private"
}
