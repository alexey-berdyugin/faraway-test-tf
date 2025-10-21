data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = "berdyugin-faraway-test-terraform-state"
    key    = "envs/dev/vpc/terraform.tfstate"
    region = "us-east-1"
  }
}

module "eks" {
  source = "../../../modules/eks"

  region          = "us-west-2"
  cluster_name    = "dev-eks"
  cluster_version = "1.34"
  vpc_id          = data.terraform_remote_state.vpc.outputs.vpc_id
  subnet_ids      = data.terraform_remote_state.vpc.outputs.private_subnets

  environment = "dev"
}
