module "vpc" {
  source = "../../../modules/vpc"

  region          = "us-east-1"
  vpc_name        = "dev-vpc"
  vpc_cidr        = "172.16.0.0/16"
  azs             = ["us-east-1a", "us-east-1b"]
  public_subnets  = ["172.16.0.0/24", "172.16.1.0/24"]
  private_subnets = ["172.16.10.0/23", "172.16.12.0/23"]
  environment     = "dev"
}
